INSERT INTO media_type_table
SELECT
    `MediaTypeId`,
    `AvailableDiskSlot`,
    `UsbSlotType`,
    `UsbSlots`,
    `IsTouchDisplay`
FROM MediaType;