CREATE TABLE customer_agg_5m (
  `CustomerId`   INT,
  `window_start` TIMESTAMP(3),
  `window_end`   TIMESTAMP(3),
  `customer_total_assets` INT,
  PRIMARY KEY (`CustomerId`) NOT ENFORCED
) 
DISTRIBUTED INTO 1 BUCKETS
WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);
