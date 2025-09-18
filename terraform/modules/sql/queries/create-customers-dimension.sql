CREATE TABLE customer_table (
    `CustomerId` INT,
    `FirstName` STRING,
    `LastName` STRING,
    `Email` STRING,
    `CustomerTypeId` INT,
    `CustomerTypeText` STRING,
    `JoinDate` INT,
    `ProfileImage` STRING,
    `IsSuspended` INT,
    `SuspendedReasonId` INT,
    `SuspendedReasonText` STRING,
    `AuthTypeId` INT,
    PRIMARY KEY (`CustomerId`) NOT ENFORCED
)
DISTRIBUTED INTO 1 BUCKETS 
WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset',
  'kafka.consumer.isolation-level' = 'read-uncommitted'
);