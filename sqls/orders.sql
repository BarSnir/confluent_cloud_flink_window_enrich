-- CREATE TABLE orders_extract (
--   `OrderId` STRING,
--   `SiteToken` STRING,
--   `Price` INT,
--   `StatusId` INT,
--   `CustomerId` INT,
--   PRIMARY KEY(`OrderId`) NOT ENFORCED
-- ) WITH (
--   'changelog.mode'='append',
--   'kafka.cleanup-policy'='compact',
--   'value.format' = 'avro-registry',
--   'scan.startup.mode' = 'earliest-offset'
-- );

-- INSERT INTO orders_extract (
--   `OrderId`,
--   `SiteToken`,
--   `Price`,
--   `StatusId`,
--   `CustomerId`
-- )
-- SELECT 
--   Orders.OrderId,
--   Orders.SiteToken,
--   Orders.Price,
--   Orders.StatusId,
--   Orders.CustomerId 
-- FROM Orders;


ALTER TABLE `Orders` SET (
  'changelog.mode' = 'append'
);

-- DROP TABLE orders_extract;