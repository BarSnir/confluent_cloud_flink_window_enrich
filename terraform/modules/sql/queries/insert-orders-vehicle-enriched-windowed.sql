INSERT INTO orders_vehicle_enriched_windowed
SELECT
  ove.OrderId,
  ove.SiteToken,
  ove.Price,
  ove.StatusId,
  ove.CustomerId,

  ove.VehicleId,
  ove.KM,
  ove.PrevOwnerNumber,

  ove.MarketInfoId,
  ove.MediaTypeId,
  ove.YearOnRoad,
  ove.TestDate,
  ove.ImproveId,

  ove.images_count,
  ove.images_urls,

  ove.StageLevel,
  ove.StageText,
  ove.PartsImprovedList,

  ove.AirBags,
  ove.SunRoof,
  ove.MagnesiumWheels,
  ove.ReversSensors,
  ove.ABS,
  ove.Hybrid,
  ove.Doors,
  ove.EnvironmentFriendlyLevel,
  ove.SecurityTestLevel,
  ove.ManufacturerId,
  ove.ManufacturerText,
  ove.ModelId,
  ove.ModelText,
  ove.SubModelId,
  ove.SubModelText,
  ove.FamilyTypeId,
  ove.FamilyTypeText,
  ove.Year,
  ove.HorsePower,
  ove.CruseControl,
  ove.PowerWheel,
  ove.FullyAutonomic,
  ove.MarketPrice,

  ove.AvailableDiskSlot,
  ove.UsbSlotType,
  ove.UsbSlots,
  ove.IsTouchDisplay,

  cal.window_start,
  cal.window_end,
  cal.customer_total_assets
FROM orders_vehicle_enriched ove
JOIN customer_agg_5m FOR SYSTEM_TIME AS OF o.`$rowtime` AS cal
ON ove.CustomerId = cal.CustomerId;