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
- Kafka Connect Debezium [✅]
- Kafka Connect MinIO, Elasticsearch, Neo4j []
- Producer Generator to database []
- Elasticsearch [✅]
- Kibana [✅]
- Neo4j [✅]
- MinIO [✅]

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
- Flink Create target Table Statements []

3. Assets:
- Temporal join

# Installation
1. Terraform:
- ! Don't forget:
```export CONFLUENT_CLOUD_API_KEY=XXX```
```export CONFLUENT_CLOUD_API_SECRET=XXX``

- ```cd terraform```
- ```terraform init```
- ```terraform plan -target=module.cores -out=cores```
- ```terraform apply cores```
- ```terraform output -json >> secrets.json```
`

2. .env Set:
- Create .env file contains values as in the .env.exmple
- Please use the secrets.json to fill the details


3. Compose:
- docker compose up -d
- Inspect pyflink-client notes

4. Terraform (again): for SQL running

- Export required envs in terminal
```
export CONFLUENT_ORGANIZATION_ID="xxx" \
CONFLUENT_ENVIRONMENT_ID="env-xxx" \
FLINK_COMPUTE_POOL_ID="lfcp-xxx" \
FLINK_PRINCIPAL_ID="sa-xxx" \
FLINK_REST_ENDPOINT="https://flink.xxx.xxx.confluent.cloud" \
FLINK_API_KEY="xxx" \
FLINK_API_SECRET="xxx"
```

- ```terraform plan -target=module.sql -out=sql```
- ```terraform apply sql```

5. Connect Elasticsearch, MinIO & Neo4j
- 


docker compose build orders-enricher
docker compose --profile enricher up orders-enricher -d

6. Run the generator to see the Demo in action

# SQLs
## Temporal Join construct:
1.  


Change the Fact Source Table to ```append```
```
ALTER TABLE `Orders` SET (
  'changelog.mode' = 'append'
);
```
2. Create Update table with Primary Key:
```
CREATE TABLE vehicles_extract (
    `OrderId` STRING,
    `VehicleId` STRING,
    `KM` INT,
    `PrevOwnerNumber` INT,
    `MarketInfoId` STRING,
    `MediaTypeId` INT,
    `YearOnRoad` INT,
    `TestDate` INT,
    `ImproveId` INT,
    PRIMARY KEY (`OrderId`) NOT ENFORCED
) WITH (
  'changelog.mode'='retract',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);

INSERT INTO vehicles_extract (
    `VehicleId`,
    `KM`,
    `PrevOwnerNumber`,
    `OrderId`,
    `MarketInfoId`,
    `MediaTypeId`,
    `YearOnRoad`,
    `TestDate` ,
    `ImproveId`
)
SELECT 
  Vehicles.VehicleId,
  Vehicles.KM,
  Vehicles.PrevOwnerNumber,
  Vehicles.OrderId,
  Vehicles.MarketInfoId,
  Vehicles.MediaTypeId,
  Vehicles.YearOnRoad,
  Vehicles.TestDate,
  Vehicles.ImproveId
FROM Vehicles;

```
3. Temporal Join:
```
SELECT
  v.`KM`
FROM `Orders` AS o
JOIN `vehicles_extract` FOR SYSTEM_TIME AS OF o.`$rowtime` AS v
  ON o.OrderId = v.OrderId;
```

