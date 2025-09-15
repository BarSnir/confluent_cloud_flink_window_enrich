CREATE TABLE orders_vehicle_enriched (
    `OrderId` STRING,
    `SiteToken` STRING,
    `Price` BIGINT,
    `StatusId` INT,
    `CustomerId` INT,

    `VehicleId` STRING,
    `KM` INT,
    `PrevOwnerNumber` SMALLINT,

    `MarketInfoId` STRING,
    `MediaTypeId` INT,
    `YearOnRoad` INT,
    `TestDate` INT,
    `ImproveId` INT,

    `images_count` BIGINT,
    `images_urls` ARRAY<STRING>,

    `StageLevel` SMALLINT,
    `StageText` STRING,
    `PartsImprovedList` STRING,

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

    `AvailableDiskSlot` INT,
    `UsbSlotType` STRING,
    `UsbSlots` INT,
    `IsTouchDisplay` INT,
    `CustomerName` STRING,
    `CustomerEmail` STRING,
    `pipeline_start` TIMESTAMP_LTZ(3) METADATA FROM 'timestamp' VIRTUAL
) 
DISTRIBUTED INTO 1 BUCKETS
WITH (
  'changelog.mode'='append',
  'kafka.cleanup-policy'='delete',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);
