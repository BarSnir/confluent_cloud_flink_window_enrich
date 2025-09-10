CREATE TABLE improving_parts_table (
    `ImproveId` INT,
    `StageLevel` TINYINT,
    `StageText` STRING,
    `PartsImprovedList` STRING,
    PRIMARY KEY (`ImproveId`) NOT ENFORCED
) WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);
