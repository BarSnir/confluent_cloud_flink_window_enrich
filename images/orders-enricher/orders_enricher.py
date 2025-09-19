#!/usr/bin/env python3
"""
Kafka→Elasticsearch DIM enricher (Confluent Cloud, Avro + Schema Registry, Debezium envelope).

Flow per record (Orders topic):
  1) Deserialize Avro (Debezium envelope with `before` / `after`).
  2) Extract OrderId, CustomerId, etc. from `after`. Ignore tombstones / deletes (optionally delete in ES).
  3) Search vehicle_table by OrderId (term on OrderId) ⇒ get VehicleId (doc _id) + ImproveId/MarketInfoId/MediaTypeId.
  4) mget all relevant DIM docs by their IDs: customer_table, customer_agg_5m, improving_parts_table, market_info_table, media_type_table.
  5) Build enriched doc with:
       - pipeline_start  (Kafka record timestamp)  → ISO8601 UTC with millis 'Z' + pipeline_start_ms
       - ingest_ts       (now at ingest)           → ISO8601 UTC with millis 'Z' + ingest_ts_ms
       - latency_ms      (ingest_ts_ms - pipeline_start_ms)
  6) Index into Elasticsearch index IDX_OUT (default: orders_enriched) with _id = OrderId.
  7) Commit Kafka offset only after successful index.
"""

import os
import sys
import time
import logging
from typing import Any, Dict, Optional
from datetime import datetime, timezone

from dotenv import load_dotenv

from confluent_kafka import DeserializingConsumer, KafkaException
from confluent_kafka.serialization import StringDeserializer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroDeserializer

from elasticsearch import Elasticsearch

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
    # msg.timestamp() -> (type, ts_ms)  where type is 0|1 (CreateTime/LogAppendTime)
    ttype, ts = msg.timestamp()
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
    conf = {
        "bootstrap.servers": f'{getenv_required("CCLOUD_BROKER_HOST")}:9092',
        "security.protocol": os.getenv("SECURITY_PROTOCOL", "SASL_SSL"),
        "sasl.mechanism": os.getenv("SASL_MECHANISM", "PLAIN"),
        "sasl.username": getenv_required("CCLOUD_API_KEY"),
        "sasl.password": getenv_required("CCLOUD_API_SECRET"),
        "group.id": os.getenv("GROUP_ID", "orders-enricher-v1"),
        "auto.offset.reset": os.getenv("AUTO_OFFSET_RESET", "earliest"),
        "enable.auto.commit": False,
        "key.deserializer": StringDeserializer()
    }
    topic = 'Orders'
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

# ---------------------- Enrichment Logic ----------------------

def search_vehicle_by_orderid(es: Elasticsearch, order_id: Any, index: str) -> Optional[Dict[str, Any]]:
    """
    Find vehicle_table doc by OrderId (not _id). Returns {'_id': VehicleId, '_source': {...}} or None.
    Assumes OrderId is mapped as keyword (per your index template).
    """
    try:
        resp = es.search(
            index=index,
            size=1,
            track_total_hits=False,
            terminate_after=1,
            query={"term": {"OrderId": str(order_id)}},
            _source=[
                "ImproveId","KM","MarketInfoId","MediaTypeId","OrderId",
                "PrevOwnerNumber","TestDate","YearOnRoad"
            ],
            request_timeout=5
        )
        hits = resp.get("hits", {}).get("hits", [])
        if hits:
            return {"_id": hits[0]["_id"], "_source": hits[0].get("_source", {})}
        return None
    except Exception as e:
        logging.exception(f"ES search vehicle_table failed for OrderId={order_id}: {e}")
        return None

def mget_dims(es: Elasticsearch, docs: Dict[str, Optional[Any]]) -> Dict[str, Optional[Dict[str, Any]]]:
    """
    docs: mapping of logical name -> (index, _id)
    Returns mapping logical name -> _source (dict) or None
    """
    request_docs = []
    name_for_slot = []
    for name, tup in docs.items():
        if not tup or tup[1] is None:
            continue
        index, _id = tup
        request_docs.append({"_index": index, "_id": str(_id)})
        name_for_slot.append(name)

    out: Dict[str, Optional[Dict[str, Any]]] = {k: None for k in docs.keys()}
    if not request_docs:
        return out

    try:
        resp = es.mget(docs=request_docs, source=True, request_timeout=5)
        for i, doc in enumerate(resp.get("docs", [])):
            name = name_for_slot[i] if i < len(name_for_slot) else f"slot{i}"
            if doc.get("found"):
                out[name] = doc.get("_source", {})
            else:
                out[name] = None
    except Exception as e:
        logging.exception(f"ES mget failed: {e}")
    return out

def build_enriched_doc(order_after: Dict[str, Any],
                       vehicle_hit: Optional[Dict[str, Any]],
                       dims: Dict[str, Optional[Dict[str, Any]]],
                       kafka_ts: int,
                       ingest_ts: int) -> Dict[str, Any]:
    latency = max(0, ingest_ts - kafka_ts)
    enriched = {
        # ISO8601 UTC with milliseconds and trailing 'Z'
        "pipeline_start": fmt_iso(kafka_ts),
        "ingest_ts": fmt_iso(ingest_ts),
        # Raw millis for analytics/aggregations
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
            "customer": dims.get("customer_table"),
            "customer_agg_5m": dims.get("customer_agg_5m"),
            "market_info": dims.get("market_info_table"),
            "media_type": dims.get("media_type_table"),
            "improving_parts": dims.get("improving_parts_table"),
        }
    }
    # also include VehicleId from ES _id if we found the vehicle doc
    if vehicle_hit:
        enriched["dim"]["vehicle_id"] = vehicle_hit["_id"]
    return enriched

def handle_delete(es: Elasticsearch, index_out: str, order_id: Any):
    try:
        es.delete(index=index_out, id=str(order_id), ignore=[404])
    except Exception as e:
        logging.exception(f"Failed to delete {order_id} from {index_out}: {e}")

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

    print(f"[INFO] Starting loop. Output index={idx_out}")
    try:
        while True:
            msg = consumer.poll(1.0)
            if msg is None:
                continue
            if msg.error():
                raise KafkaException(msg.error())

            t_ms = kafka_ts_ms(msg)
            v = msg.value()  # AvroDeserializer -> Python dict

            if v is None:
                # tombstone (null value) - optional delete
                key = msg.key()
                if delete_on_tombstone and key is not None:
                    handle_delete(es, idx_out, key)
                    consumer.commit(msg, asynchronous=False)
                continue

            # Debezium envelope
            after = v.get("after")
            op = v.get("op")
            # Delete events typically have after=None and/or op='d'
            if after is None:
                if delete_on_tombstone:
                    key = msg.key() or (v.get("before") or {}).get("OrderId")
                    if key is not None:
                        handle_delete(es, idx_out, key)
                        consumer.commit(msg, asynchronous=False)
                continue

            order_id = after.get("OrderId")
            cust_id  = after.get("CustomerId")
            ingest_ts = now_ms()

            # 1) vehicle by OrderId (to obtain VehicleId + foreign keys)
            vehicle_hit = search_vehicle_by_orderid(es, order_id, idx_vehicle)

            # 2) prepare mget docs for all other dims
            docs = {
                "customer_table":       (idx_customer,  cust_id),
                "customer_agg_5m":      (idx_cust_agg,  cust_id),
                "market_info_table":    (idx_market,   (vehicle_hit or {}).get("_source", {}).get("MarketInfoId")),
                "media_type_table":     (idx_media,    (vehicle_hit or {}).get("_source", {}).get("MediaTypeId")),
                "improving_parts_table":(idx_improve,  (vehicle_hit or {}).get("_source", {}).get("ImproveId")),
            }
            dims = mget_dims(es, docs)

            # 3) build enriched doc
            doc = build_enriched_doc(after, vehicle_hit, dims, kafka_ts=t_ms, ingest_ts=ingest_ts)

            # 4) index/upsert
            try:
                es.index(index=idx_out, id=str(order_id), document=doc, request_timeout=5)
            except Exception as e:
                logging.exception(f"Failed to index enriched doc order_id={order_id}: {e}")
                # don't commit on failure; message will be retried
                continue

            # 5) commit after success
            consumer.commit(msg, asynchronous=False)

    except KeyboardInterrupt:
        print("[INFO] Shutting down (Ctrl+C).")
    finally:
        try:
            consumer.close()
        except Exception:
            pass

if __name__ == "__main__":
    main()
