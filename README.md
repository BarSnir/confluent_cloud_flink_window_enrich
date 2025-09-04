# confluent_cloud_flink_window_enrich
Short POC to examine the power of Flink when windowing a topic and enriching the incoming windowed events with dimension tables.

# Demo Planning:
## Goals
1. Debezium fetching on-premies 6 MySql tables. 
2. Create Fact data generator
3. Events produced to Confluent Cloud with Avro
4. Flink enrich data 6 tables data
5. Flink windowing 5 min events
6. Distribute with Kafka Connect to MinIO, Elasticsearch & Neo4j

## Infrastructure:
1. Docker Compose:
- MySql with Loaded Data
- Kafka Connect Debezium
- Kafka Connect MinIO, Elasticsearch, Neo4j
- Producer Generator to database
2. Terraform
- Creating CC cluster
- Creating Flink Compute pool
- Creating Job with Flink SQL
- Creating schemas to results topic