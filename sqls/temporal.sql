SELECT
  v.`KM`
FROM `Orders` AS o
JOIN `vehicles_extract` FOR SYSTEM_TIME AS OF o.`$rowtime` AS v
  ON o.OrderId = v.OrderId;