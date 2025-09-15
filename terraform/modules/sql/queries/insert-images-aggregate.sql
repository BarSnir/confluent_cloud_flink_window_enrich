INSERT INTO images_aggregate
SELECT
  OrderId AS images_order_id,
  COUNT(*) AS images_count,
  ARRAY_AGG(Url) AS images_urls
FROM Images
GROUP BY OrderId;