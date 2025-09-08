SELECT window_start, window_end, OrderId, SUM(Price) as `sum`
  FROM TABLE(
    TUMBLE(TABLE `orders_extract`, DESCRIPTOR($rowtime), INTERVAL '5' MINUTES))
  GROUP BY window_start, window_end, OrderId;