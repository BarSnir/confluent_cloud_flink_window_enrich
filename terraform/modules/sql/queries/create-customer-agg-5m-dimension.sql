CREATE TABLE customer_agg_5m (
  `window_start` TIMESTAMP(3),
  `window_end`   TIMESTAMP(3),
  `CustomerId`   INT,
  `customer_total_assets` DECIMAL(18,2),
  PRIMARY KEY (`window_start`, `window_end`, `CustomerId`) NOT ENFORCED
) WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);
