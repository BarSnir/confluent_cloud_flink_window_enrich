CREATE TABLE vehicle_table (
    `VehicleId` STRING,
    `KM` INT,
    `PrevOwnerNumber` TINYINT,
    `OrderId` STRING,
    `MarketInfoId` STRING,
    `MediaTypeId` INT,
    `YearOnRoad` INT,
    `TestDate` INT,
    `ImproveId` INT,
    PRIMARY KEY (`VehicleId`) NOT ENFORCED
) 
DISTRIBUTED INTO 1 BUCKETS
WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset',
  'kafka.consumer.isolation-level' = 'read-uncommitted'
);