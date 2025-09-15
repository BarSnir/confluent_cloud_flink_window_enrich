INSERT INTO customer_table
SELECT
    `CustomerId`,
    `FirstName`,
    `LastName`,
    `Email`,
    `CustomerTypeId`,
    `CustomerTypeText`,
    `JoinDate`,
    `ProfileImage`,
    `IsSuspended`,
    `SuspendedReasonId`,
    `SuspendedReasonText`,
    `AuthTypeId`
FROM Customers;