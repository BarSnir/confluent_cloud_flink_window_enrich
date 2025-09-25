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
7. Monitor it

## Infrastructure:

1. Docker Compose:
- MySql with Loaded Data[✅]
- Kafka Connect Debezium [✅]
- Kafka Connect MinIO, Elasticsearch, Neo4j [✅]
- Producer Generator to database [✅]
- Elasticsearch [✅]
- Kibana [✅]
- Neo4j [✅]
- MinIO [✅]
- Monitoring with Prometheus & Grafana [✅]

2. Terraform
- Connectors API Key [✅]
- Connectors API Secret [✅]
- Connectors Service Account ID [✅]
- Environment ID [✅]
- Flink Compute Pool ID [✅]
- Kafka Bootstrap Endpoint [✅]
- Kafka Cluster ID [✅]
- Schema Registry API Key [✅]
- Schema Registry API Secret [✅]
- Schema Registry ID [✅]
- Schema Registry Service Account ID [✅]
- Flink API Key [✅]
- Flink API Secret [✅]
- Flink Create target Table Statements [✅]

# Installation
1. Terraform: (In Terraform Terminal, cd terraform)
- ! Don't forget:
```export CONFLUENT_CLOUD_API_KEY=XXX```
```export CONFLUENT_CLOUD_API_SECRET=XXX``

- ```cd terraform```
- ```terraform init```
- ```terraform plan -target=module.cores -out=cores```
- ```terraform apply cores```
- ```terraform output -json >> secrets.json```

⚠️  If you run this Demo more than once, please remove ```secrets.json``` under terraform folder
⚠️  Didn't fixed yet issue for recognize schema registry not found in cluster,
Just re-plan modules.core and re-apply


2. .env Set:
- Create .env with ```python3 generate_env.py <CONFLUENT_ORG_ID>```
- From ```generate_env.py ``` output:
```
export CONFLUENT_ORGANIZATION_ID="xxx" \
CONFLUENT_ENVIRONMENT_ID="env-xxx" \
FLINK_COMPUTE_POOL_ID="lfcp-xxx" \
FLINK_PRINCIPAL_ID="sa-xxx" \
FLINK_REST_ENDPOINT="https://flink.xxx.xxx.confluent.cloud" \
FLINK_API_KEY="xxx" \
FLINK_API_SECRET="xxx"
```
⚠️ In Terraform terminal


3. Compose infrastructure: ```docker compose up -d```

4. Compose Data processes with Flink: 
- Set ENV in docker-compose.yaml of Pyflink-Client container to ```PROCESS_STEP=step_a```
- ```docker compose --profile pyflink-client up pyflink-client --build --force-recreate ```

5. Terraform (again): for SQL running (In Terraform Terminal)
- ```terraform plan -target=module.sql -out=sql```
- ```terraform apply sql```

5. Compose Data flow with Kafka Connectors: 
- Set ENV in docker-compose.yaml of Pyflink-Client container to ```PROCESS_STEP=step_b```
- ```docker compose --profile pyflink-client up pyflink-client --force-recreate```
- Right now Data Is flowing with Flink SQL, Kafka & Connectors E2E

6. Let optimize the pipeline to be soft real-time:
- ```docker compose build orders-enricher```
- ```docker compose --profile enricher up orders-enricher```

7. Compose Data processes with Flink: 
- Set ENV in docker-compose.yaml of Pyflink-Client container to ```PROCESS_STEP=step_c```
- ```docker compose --profile pyflink-client up pyflink-client --force-recreate```
- Load the database with more Orders

⚠️ We can repeat this process how ever we want


8. Inspect Monitor Under localhost:3000 - Under the dashboards. 