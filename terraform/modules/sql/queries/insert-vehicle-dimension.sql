INSERT INTO vehicle_table
SELECT
  VehicleId,
  KM,
  CAST(PrevOwnerNumber AS TINYINT)  PrevOwnerNumber,
  OrderId,
  MarketInfoId,
  MediaTypeId,
  YearOnRoad,
  TestDate,
  ImproveId
FROM Vehicles;