CREATE TABLE orders_vehicle_enriched_windowed (
  `OrderId` STRING,
  `SiteToken` STRING,
  `Price`    DOUBLE,
  `StatusId` INT,
  `CustomerId` INT,

  `VehicleId` STRING,
  `KM` INT,
  `PrevOwnerNumber` TINYINT,

  `MarketInfoId` STRING,
  `MediaTypeId` INT,
  `YearOnRoad` INT,
  `TestDate` DATE,
  `ImproveId` INT,

  `images_count` BIGINT,
  `images_urls` ARRAY<STRING>,

  `StageLevel` TINYINT,
  `StageText` STRING,
  `PartsImprovedList` STRING,

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

  `AvailableDiskSlot` INT,
  `UsbSlotType` STRING,
  `UsbSlots` INT,
  `IsTouchDisplay` INT,

  `window_start` TIMESTAMP(3),
  `window_end`   TIMESTAMP(3),
  `customer_total_assets` BIGINT
) WITH (
  'changelog.mode'='append',
  'kafka.cleanup-policy'='delete',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);
