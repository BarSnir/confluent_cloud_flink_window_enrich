CREATE TABLE vehicle_enriched (
    `OrderId` STRING,
    `VehicleId` STRING,
    `KM` INT,
    `PrevOwnerNumber` SMALLINT,
    `MarketInfoId` STRING,
    `MediaTypeId` INT,
    `YearOnRoad` INT,
    `TestDate` INT,
    `ImproveId` INT,

    -- Images aggregate
    `images_count` BIGINT,
    `images_urls` ARRAY<STRING>,

    -- Improving parts
    `StageLevel` SMALLINT,
    `StageText` STRING,
    `PartsImprovedList` STRING,

    -- Market info
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

    -- Media type
    `AvailableDiskSlot` INT,
    `UsbSlotType` STRING,
    `UsbSlots` INT,
    `IsTouchDisplay` INT,

    PRIMARY KEY (`OrderId`) NOT ENFORCED
) 
DISTRIBUTED INTO 1 BUCKETS
WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset',
  'kafka.consumer.isolation-level' = 'read-uncommitted'
);
