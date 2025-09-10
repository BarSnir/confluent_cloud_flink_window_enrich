INSERT INTO customer_agg_5m
SELECT
  window_start,
  window_end,
  CustomerId,
  SUM(Price) AS customer_total_assets
FROM TABLE(
  TUMBLE(TABLE Orders, DESCRIPTOR($rowtime), INTERVAL '5' MINUTES)
)
GROUP BY window_start, window_end, CustomerId;