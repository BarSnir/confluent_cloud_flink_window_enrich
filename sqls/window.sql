SELECT window_start, window_end, OrderId, SUM(Price) as `sum`
  FROM TABLE(
    TUMBLE(TABLE `Orders`, DESCRIPTOR($rowtime), INTERVAL '5' MINUTES))
  GROUP BY window_start, window_end, OrderId;