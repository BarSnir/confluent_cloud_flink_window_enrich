INSERT INTO customer_agg_5m
SELECT
  CustomerId,
  LAST_VALUE(window_start) window_start,
  LAST_VALUE(window_end) window_end,
  CAST(SUM(Price) AS INT)  AS customer_total_assets
FROM TABLE(
  TUMBLE(TABLE Orders, DESCRIPTOR($rowtime), INTERVAL '5' MINUTES)
)
GROUP BY CustomerId;