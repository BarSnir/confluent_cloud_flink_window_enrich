CREATE TABLE images_aggregate (
    `images_order_id` STRING,
    `images_count` BIGINT,
    `images_urls` ARRAY<STRING>,
    PRIMARY KEY (`images_order_id`) NOT ENFORCED
) 
DISTRIBUTED INTO 1 BUCKETS
WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset',
  'kafka.consumer.isolation-level' = 'read-uncommitted'
);