CREATE TABLE customer_table (
    `CustomerId` INT,
    `FirstName` STRING,
    `LastName` STRING,
    `Email` STRING,
    `CustomerTypeId` INT,
    `CustomerTypeText` STRING,
    `JoinDate` DATE,
    `ProfileImage` STRING,
    `IsSuspended` INT,
    `SuspendedReasonId` INT,
    `SuspendedReasonText` STRING,
    `AuthTypeId` INT,
    PRIMARY KEY (`CustomerId`) NOT ENFORCED
) WITH (
  'changelog.mode'='upsert',
  'kafka.cleanup-policy'='compact',
  'value.format' = 'avro-registry',
  'scan.startup.mode' = 'earliest-offset'
);