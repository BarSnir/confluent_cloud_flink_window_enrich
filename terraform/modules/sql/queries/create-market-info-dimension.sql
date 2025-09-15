CREATE TABLE market_info_table (
    `MarketInfoId` STRING,
    `AirBags` INT,
    `SunRoof` SMALLINT,
    `MagnesiumWheels` SMALLINT,
    `ReversSensors` SMALLINT,
    `ABS` SMALLINT,
    `Hybrid` SMALLINT,
    `Doors` SMALLINT,
    `EnvironmentFriendlyLevel` INT,
    `SecurityTestLevel` INT,
    `ManufacturerId` INT,
    `ManufacturerText` STRING,
    `ModelId` INT,
    `ModelText` STRING,
    `SubModelId` INT,
    `SubModelText` STRING,
    `FamilyTypeId` INT,
    `FamilyTypeText` STRING,
    `Year` INT,
    `HorsePower` INT,
    `CruseControl` SMALLINT,
    `PowerWheel` SMALLINT,
    `FullyAutonomic` SMALLINT,
    `MarketPrice` INT,
    PRIMARY KEY (`MarketInfoId`) NOT ENFORCED
) 
DISTRIBUTED INTO 1 BUCKETS
WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);