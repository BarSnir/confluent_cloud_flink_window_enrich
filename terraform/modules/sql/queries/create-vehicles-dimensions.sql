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