INSERT INTO orders_vehicle_enriched
SELECT
  o.OrderId,
  o.SiteToken,
  o.Price,
  o.StatusId,
  o.CustomerId,

  ve.VehicleId,
  ve.KM,
  ve.PrevOwnerNumber,

  ve.MarketInfoId,
  ve.MediaTypeId,
  ve.YearOnRoad,
  ve.TestDate,
  ve.ImproveId,

  ve.images_count,
  ve.images_urls,

  ve.StageLevel,
  ve.StageText,
  ve.PartsImprovedList,

  ve.AirBags,
  ve.SunRoof,
  ve.MagnesiumWheels,
  ve.ReversSensors,
  ve.`ABS`,
  ve.Hybrid,
  ve.Doors,
  ve.EnvironmentFriendlyLevel,
  ve.SecurityTestLevel,
  ve.ManufacturerId,
  ve.ManufacturerText,
  ve.ModelId,
  ve.ModelText,
  ve.SubModelId,
  ve.SubModelText,
  ve.FamilyTypeId,
  ve.FamilyTypeText,
  ve.`Year`,
  ve.HorsePower,
  ve.CruseControl,
  ve.PowerWheel,
  ve.FullyAutonomic,
  ve.MarketPrice,

  ve.AvailableDiskSlot,
  ve.UsbSlotType,
  ve.UsbSlots,
  ve.IsTouchDisplay
FROM Orders o
JOIN vehicle_enriched FOR SYSTEM_TIME AS OF o.`$rowtime` AS ve
ON ve.OrderId = o.OrderId;
