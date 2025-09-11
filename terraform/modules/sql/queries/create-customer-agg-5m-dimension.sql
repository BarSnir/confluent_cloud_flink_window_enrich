CREATE TABLE customer_agg_5m (
  `CustomerId`   INT,
  `window_start` TIMESTAMP(3),
  `window_end`   TIMESTAMP(3),
  `customer_total_assets` DECIMAL(18,2),
  PRIMARY KEY (`CustomerId`) NOT ENFORCED
) WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);
