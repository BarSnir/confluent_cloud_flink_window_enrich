CREATE TABLE images_table (
    `ImageId` STRING,
    `OrderId` STRING,
    `Url` STRING,
    `Priority` INT,
    PRIMARY KEY (`ImageId`) NOT ENFORCED
) 
DISTRIBUTED INTO 1 BUCKETS
WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset',
  'kafka.consumer.isolation-level' = 'read-uncommitted'
);