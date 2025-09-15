CREATE TABLE improving_parts_table (
    `ImproveId` INT,
    `StageLevel` SMALLINT,
    `StageText` STRING,
    `PartsImprovedList` STRING,
    PRIMARY KEY (`ImproveId`) NOT ENFORCED
) 
DISTRIBUTED INTO 1 BUCKETS
WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);
