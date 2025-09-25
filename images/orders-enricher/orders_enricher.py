#!/usr/bin/env python3
"""
Kafka→Elasticsearch DIM enricher (Confluent Cloud, Avro + Schema Registry, Debezium envelope).



import os
import sys
import time
import logging
from typing import Any, Dict, Optional, List, Tuple, Set
from datetime import datetime, timezone

from dotenv import load_dotenv

from confluent_kafka import DeserializingConsumer, KafkaException, TopicPartition
from confluent_kafka.serialization import StringDeserializer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroDeserializer

from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk

# ---------------------- Config & Helpers ----------------------

def getenv_required(name: str) -> str:
    val = os.getenv(name)
    if not val:
        print(f"[ERROR] Missing required environment variable: {name}", file=sys.stderr)
        sys.exit(1)
    return val

def now_ms() -> int:
    return int(time.time() * 1000)

def fmt_iso(ts_ms: int) -> str:
    """Format milliseconds since epoch as ISO8601 UTC with milliseconds and trailing 'Z'."""
    dt = datetime.fromtimestamp(ts_ms / 1000.0, tz=timezone.utc)
    return dt.strftime('%Y-%m-%dT%H:%M:%S.%f')[:23] + 'Z'

def kafka_ts_ms(msg) -> int:
    _ttype, ts = msg.timestamp()
    return int(ts) if ts is not None else now_ms()

def build_sr_and_deserializer(topic: str, sr_url: str, sr_user: str, sr_pass: str) -> AvroDeserializer:
    client = SchemaRegistryClient({
        "url": sr_url,
        "basic.auth.user.info": f"{sr_user}:{sr_pass}"
    })
    subject = f"{topic}-value"
    meta = client.get_latest_version(subject)
    schema_str = meta.schema.schema_str
    return AvroDeserializer(client, schema_str)

def build_consumer() -> DeserializingConsumer:
    load_dotenv(os.getenv("ENV_PATH", ".env"))

    broker_host = getenv_required("CCLOUD_BROKER_HOST")
    bootstrap = broker_host if ":" in broker_host else f"{broker_host}:9092"

    conf = {
        "bootstrap.servers": bootstrap,
        "security.protocol": os.getenv("SECURITY_PROTOCOL", "SASL_SSL"),
        "sasl.mechanism": os.getenv("SASL_MECHANISM", "PLAIN"),
        "sasl.username": getenv_required("CCLOUD_API_KEY"),
        "sasl.password": getenv_required("CCLOUD_API_SECRET"),

        "group.id": os.getenv("GROUP_ID", "orders-enricher-v1"),
        "auto.offset.reset": os.getenv("AUTO_OFFSET_RESET", "earliest"),

        "enable.auto.commit": False,
        "key.deserializer": StringDeserializer(),

        # Throughput/latency knobs (tweak via env)
        "fetch.wait.max.ms": int(os.getenv("FETCH_WAIT_MAX_MS", "20")),
        "fetch.min.bytes": int(os.getenv("FETCH_MIN_BYTES", "1")),
        "queued.max.messages.kbytes": int(os.getenv("QUEUED_MAX_MESSAGES_KB", "131072")),
        "max.poll.interval.ms": int(os.getenv("MAX_POLL_INTERVAL_MS", "300000")),
        "socket.keepalive.enable": True,
    }

    topic = os.getenv("ORDERS_TOPIC", "Orders")
    sr_url  = getenv_required("CCLOUD_SCHEMA_REGISTRY_URL")
    sr_user = getenv_required("CCLOUD_SCHEMA_REGISTRY_API_KEY")
    sr_pass = getenv_required("CCLOUD_SCHEMA_REGISTRY_API_SECRET")
    value_deser = build_sr_and_deserializer(topic, sr_url, sr_user, sr_pass)
    conf["value.deserializer"] = value_deser

    consumer = DeserializingConsumer(conf)
    consumer.subscribe([topic])
    return consumer

def build_es() -> Elasticsearch:
    url = getenv_required("ELASTICSEARCH_URL")
    user = os.getenv("ELASTIC_USER")
    password = os.getenv("ELASTIC_PASSWORD")
    verify_certs = os.getenv("ELASTIC_VERIFY_CERTS", "false").lower() == "true"

    if user and password:
        es = Elasticsearch(url, basic_auth=(user, password), verify_certs=verify_certs)
    else:
        es = Elasticsearch(url, verify_certs=verify_certs)

    try:
        es.info()
    except Exception as e:
        print(f"[WARN] Could not call ES info(): {e}", file=sys.stderr)
    return es

# ---------------------- Batch ES Helpers ----------------------

def batch_search_vehicle_by_orderids(
    es: Elasticsearch, index: str, order_ids: List[Any]
) -> Dict[str, Dict[str, Any]]:
    """
    One search (terms) to fetch vehicles for all order_ids in the batch.
    Returns: { str(OrderId) : {'_id': VehicleId, '_source': {...}} }
    """
    if not order_ids:
        return {}
    # unique & stringify (keyword field)
    ids = list({str(x) for x in order_ids if x is not None})
    try:
        resp = es.search(
            index=index,
            size=len(ids),                         # small batch (<< 10k default window)
            track_total_hits=False,
            query={"terms": {"OrderId": ids}},
            _source=[
                "ImproveId","KM","MarketInfoId","MediaTypeId","OrderId",
                "PrevOwnerNumber","TestDate","YearOnRoad"
            ],
            request_timeout=10
        )
        out: Dict[str, Dict[str, Any]] = {}
        for hit in resp.get("hits", {}).get("hits", []):
            src = hit.get("_source", {}) or {}
            oid = str(src.get("OrderId"))
            if oid not in out:  # first wins if duplicates
                out[oid] = {"_id": hit.get("_id"), "_source": src}
        return out
    except Exception as e:
        logging.exception(f"ES batch vehicle search failed: {e}")
        return {}

def mget_by_index(
    es: Elasticsearch, index_to_ids: Dict[str, Set[Any]]
) -> Dict[str, Dict[str, Dict[str, Any]]]:
    """
    One mget across indices. Returns:
    {
      'customer_table': { '<id>': {doc}, ... },
      'market_info_table': { '<id>': {doc}, ... },
      ...
    }
    """
    docs = []
    idx_list = []
    id_list = []
    for idx, ids in index_to_ids.items():
        for _id in ids:
            if _id is None:
                continue
            docs.append({"_index": idx, "_id": str(_id)})
            idx_list.append(idx)
            id_list.append(str(_id))

    result: Dict[str, Dict[str, Dict[str, Any]]] = {idx: {} for idx in index_to_ids.keys()}
    if not docs:
        return result

    try:
        resp = es.mget(docs=docs, source=True, request_timeout=10)
        for i, doc in enumerate(resp.get("docs", [])):
            idx = idx_list[i]
            did = id_list[i]
            if doc.get("found"):
                result[idx][did] = doc.get("_source", {})
        return result
    except Exception as e:
        logging.exception(f"ES mget failed: {e}")
        return result

# ---------------------- Build Enriched ----------------------

def build_enriched_doc(order_after: Dict[str, Any],
                       vehicle_hit: Optional[Dict[str, Any]],
                       customer: Optional[Dict[str, Any]],
                       cust_agg: Optional[Dict[str, Any]],
                       market_info: Optional[Dict[str, Any]],
                       media_type: Optional[Dict[str, Any]],
                       improving_parts: Optional[Dict[str, Any]],
                       kafka_ts: int,
                       ingest_ts: int) -> Dict[str, Any]:
    latency = max(0, ingest_ts - kafka_ts)
    enriched = {
        "pipeline_start": fmt_iso(kafka_ts),
        "ingest_ts": fmt_iso(ingest_ts),
        "pipeline_start_ms": kafka_ts,
        "ingest_ts_ms": ingest_ts,
        "latency_ms": latency,
        "order": {
            "OrderId": order_after.get("OrderId"),
            "SiteToken": order_after.get("SiteToken"),
            "Price": order_after.get("Price"),
            "StatusId": order_after.get("StatusId"),
            "CustomerId": order_after.get("CustomerId"),
        },
        "dim": {
            "vehicle": vehicle_hit["_source"] if vehicle_hit else None,
            "customer": customer,
            "customer_agg_5m": cust_agg,
            "market_info": market_info,
            "media_type": media_type,
            "improving_parts": improving_parts,
        }
    }
    if vehicle_hit:
        enriched["dim"]["vehicle_id"] = vehicle_hit["_id"]
    return enriched

def handle_delete(es: Elasticsearch, index_out: str, doc_id: Any):
    try:
        es.delete(index=index_out, id=str(doc_id), ignore=[404])
    except Exception as e:
        logging.exception(f"Failed to delete {doc_id} from {index_out}: {e}")

# ---------------------- Batch Collector ----------------------

def collect_batch(consumer: DeserializingConsumer,
                  max_batch: int,
                  timeout_ms: int) -> List:
    """Poll in a loop until we have up to max_batch messages or timeout elapsed."""
    deadline = time.time() + (timeout_ms / 1000.0)
    out = []
    while len(out) < max_batch and time.time() < deadline:
        msg = consumer.poll(0.05)
        if msg is None:
            continue
        if msg.error():
            continue
        out.append(msg)
    return out

# ---------------------- Main Loop ----------------------

def main():
    logging.basicConfig(
        level=getattr(logging, os.getenv("LOG_LEVEL", "INFO").upper(), logging.INFO),
        format="%(asctime)s %(levelname)s %(message)s",
        stream=sys.stdout
    )

    consumer = build_consumer()
    es = build_es()

    # Index names (overridable via env)
    idx_vehicle = os.getenv("IDX_VEHICLE", "vehicle_table")
    idx_customer = os.getenv("IDX_CUSTOMER", "customer_table")
    idx_cust_agg = os.getenv("IDX_CUSTOMER_AGG_5M", "customer_agg_5m")
    idx_market  = os.getenv("IDX_MARKET_INFO", "market_info_table")
    idx_media   = os.getenv("IDX_MEDIA_TYPE", "media_type_table")
    idx_improve = os.getenv("IDX_IMPROVING_PARTS", "improving_parts_table")
    idx_out     = os.getenv("IDX_OUT", "orders_enriched")

    delete_on_tombstone = os.getenv("DELETE_ON_TOMBSTONE", "true").lower() == "true"
    batch_size = int(os.getenv("BATCH_SIZE", "500"))
    batch_timeout_ms = int(os.getenv("BATCH_TIMEOUT_MS", "250"))

    print(f"[INFO] Starting loop. Output index={idx_out} | batch_size={batch_size} | batch_timeout_ms={batch_timeout_ms}")

    try:
        while True:
            msgs = collect_batch(consumer, batch_size, batch_timeout_ms)
            if not msgs:
                continue

            actions: List[Dict[str, Any]] = []
            last_offsets: Dict[Tuple[str, int], int] = {}

            # 1) Collect IDs from batch
            order_ids: List[Any] = []
            cust_ids: Set[Any] = set()
            records: List[Tuple[Any, Dict[str, Any], int]] = []  # (key, after, kafka_ts)

            raw_msgs: List[Any] = []

            for msg in msgs:
                raw_msgs.append(msg)
                tp = (msg.topic(), msg.partition())
                last_offsets[tp] = max(last_offsets.get(tp, -1), msg.offset())

                t_ms = kafka_ts_ms(msg)
                v = msg.value()

                # Tombstone
                if v is None:
                    if delete_on_tombstone and msg.key() is not None:
                        try:
                            handle_delete(es, idx_out, msg.key())
                        except Exception:
                            pass
                    continue

                after = v.get("after")
                if after is None:
                    if delete_on_tombstone:
                        key = msg.key() or (v.get("before") or {}).get("OrderId")
                        if key is not None:
                            try:
                                handle_delete(es, idx_out, key)
                            except Exception:
                                pass
                    continue

                order_id = after.get("OrderId")
                cust_id  = after.get("CustomerId")
                if order_id is not None:
                    order_ids.append(order_id)
                if cust_id is not None:
                    cust_ids.add(cust_id)

                records.append((msg.key(), after, t_ms))

            if not records:
                # Nothing to index; commit deletes if needed
                if last_offsets:
                    try:
                        offsets = [TopicPartition(t, p, o + 1) for (t, p), o in last_offsets.items()]
                        consumer.commit(offsets=offsets, asynchronous=True)
                    except Exception as e:
                        logging.exception(f"Commit failed: {e}")
                continue

            # 2) ONE search for all vehicles by OrderId
            orderid_to_vehicle = batch_search_vehicle_by_orderids(es, idx_vehicle, order_ids)

            # 3) Gather DIM IDs from vehicle docs
            market_ids: Set[Any] = set()
            media_ids: Set[Any] = set()
            improve_ids: Set[Any] = set()

            for oid in {str(x) for x in order_ids}:
                vhit = orderid_to_vehicle.get(oid)
                if not vhit:
                    continue
                src = vhit.get("_source", {}) or {}
                if src.get("MarketInfoId") is not None:
                    market_ids.add(src.get("MarketInfoId"))
                if src.get("MediaTypeId") is not None:
                    media_ids.add(src.get("MediaTypeId"))
                if src.get("ImproveId") is not None:
                    improve_ids.add(src.get("ImproveId"))

            # 4) ONE mget for all DIMs
            index_to_ids = {
                idx_customer: cust_ids,
                idx_cust_agg: cust_ids,
                idx_market:   market_ids,
                idx_media:    media_ids,
                idx_improve:  improve_ids,
            }
            dim_docs = mget_by_index(es, index_to_ids)
            # Flatten into easy dicts
            cust_map   = dim_docs.get(idx_customer, {})
            custagg_map= dim_docs.get(idx_cust_agg, {})
            market_map = dim_docs.get(idx_market, {})
            media_map  = dim_docs.get(idx_media, {})
            improve_map= dim_docs.get(idx_improve, {})

            # 5) Build actions for bulk
            for _key, after, t_ms in records:
                order_id = after.get("OrderId")
                cust_id  = after.get("CustomerId")
                ingest_ts = now_ms()

                vhit = orderid_to_vehicle.get(str(order_id))
                market = None
                media  = None
                impr   = None
                if vhit:
                    vs = vhit.get("_source", {}) or {}
                    mid = vs.get("MarketInfoId")
                    mtid= vs.get("MediaTypeId")
                    iid = vs.get("ImproveId")
                    if mid is not None:
                        market = market_map.get(str(mid))
                    if mtid is not None:
                        media = media_map.get(str(mtid))
                    if iid is not None:
                        impr = improve_map.get(str(iid))

                customer = cust_map.get(str(cust_id)) if cust_id is not None else None
                cust_agg = custagg_map.get(str(cust_id)) if cust_id is not None else None

                doc = build_enriched_doc(
                    order_after=after,
                    vehicle_hit=vhit,
                    customer=customer,
                    cust_agg=cust_agg,
                    market_info=market,
                    media_type=media,
                    improving_parts=impr,
                    kafka_ts=t_ms,
                    ingest_ts=ingest_ts
                )

                actions.append({
                    "_op_type": "index",
                    "_index": idx_out,
                    "_id": str(order_id),
                    "_source": doc
                })

            # 6) Bulk index this batch
            if actions:
                try:
                    bulk(es, actions, request_timeout=20, refresh=False)
                except Exception as e:
                    logging.exception(f"Bulk index failed: {e}")
                    # On failure, skip commit; will retry
                    continue

            # 7) Commit last offsets for each partition (after bulk success)
            if last_offsets:
                try:
                    offsets = [TopicPartition(t, p, o + 1) for (t, p), o in last_offsets.items()]
                    consumer.commit(offsets=offsets, asynchronous=True)
                except Exception as e:
                    logging.exception(f"Commit failed: {e}")

    except KeyboardInterrupt:
        print("[INFO] Shutting down (Ctrl+C).")
    finally:
        try:
            consumer.close()
        except Exception:
            pass

if __name__ == "__main__":
    main()
