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
- MySql with Loaded Data[✅]
- Kafka Connect Debezium
- Kafka Connect MinIO, Elasticsearch, Neo4j
- Producer Generator to database
- Elasticsearch [✅]
- Neo4j [✅]
- MinIO [✅]

2. Terraform
- Connectors API Key 
- Connectors API Secret 
- Connectors Service Account ID 
- Environment ID 
- Flink Compute Pool ID 
- Kafka Bootstrap Endpoint 
- Kafka Cluster ID 
- Schema Registry API Key 
- Schema Registry API Secret 
- Schema Registry ID 
- Schema Registry Service Account ID 

# Installation
1. Terraform:
- cd terraform
- terraform init
- terraform plan -out=standard_cc_env
- terraform apply standard_cc_env
- terraform output -json >> secrets.json 
! Don't forget:
```export CONFLUENT_CLOUD_API_KEY=XXX```
```export CONFLUENT_CLOUD_API_SECRET=XXX```

