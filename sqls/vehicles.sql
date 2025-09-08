INSERT INTO vehicles_extract (
    `VehicleId`,
    `KM`,
    `PrevOwnerNumber`,
    `OrderId`,
    `MarketInfoId`,
    `MediaTypeId`,
    `YearOnRoad`,
    `TestDate` ,
    `ImproveId`
)
SELECT 
  Vehicles.VehicleId,
  Vehicles.KM,
  Vehicles.PrevOwnerNumber,
  Vehicles.OrderId,
  Vehicles.MarketInfoId,
  Vehicles.MediaTypeId,
  Vehicles.YearOnRoad,
  Vehicles.TestDate,
  Vehicles.ImproveId
FROM Vehicles;

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

DROP TABLE vehicles_extract;