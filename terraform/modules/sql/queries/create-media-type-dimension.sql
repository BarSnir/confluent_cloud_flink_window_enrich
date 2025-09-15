CREATE TABLE media_type_table (
    `MediaTypeId` INT,
    `AvailableDiskSlot` INT,
    `UsbSlotType` STRING,
    `UsbSlots` INT,
    `IsTouchDisplay` INT,
    PRIMARY KEY (`MediaTypeId`) NOT ENFORCED
) 
DISTRIBUTED INTO 1 BUCKETS
WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);
