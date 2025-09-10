CREATE TABLE images_table (
    `ImageId` STRING,
    `OrderId` STRING,
    `Url` STRING,
    `Priority` INT,
    PRIMARY KEY (`ImageId`) NOT ENFORCED
) WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);