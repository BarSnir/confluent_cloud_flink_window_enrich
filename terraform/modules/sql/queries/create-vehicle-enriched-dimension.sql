CREATE TABLE vehicle_enriched (
    `VehicleId` STRING,
    `KM` INT,
    `PrevOwnerNumber` TINYINT,
    `OrderId` STRING,
    `MarketInfoId` STRING,
    `MediaTypeId` INT,
    `YearOnRoad` INT,
    `TestDate` DATE,
    `ImproveId` INT,

    -- Images aggregate
    `images_count` BIGINT,
    `images_urls` STRING,

    -- Improving parts
    `StageLevel` TINYINT,
    `StageText` STRING,
    `PartsImprovedList` STRING,

    -- Market info
    `AirBags` INT,
    `SunRoof` TINYINT,
    `MagnesiumWheels` TINYINT,
    `ReversSensors` TINYINT,
    `ABS` TINYINT,
    `Hybrid` TINYINT,
    `Doors` TINYINT,
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
    `CruseControl` TINYINT,
    `PowerWheel` TINYINT,
    `FullyAutonomic` TINYINT,
    `MarketPrice` INT,

    -- Media type
    `AvailableDiskSlot` INT,
    `UsbSlotType` STRING,
    `UsbSlots` INT,
    `IsTouchDisplay` INT,

    PRIMARY KEY (`VehicleId`) NOT ENFORCED
) WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);
