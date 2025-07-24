CREATE VIEW [cus].v_CUSTOMER
AS
SELECT
    CAST(customerId AS nvarchar(255)) AS [NO],
    CAST(name AS nvarchar(255)) AS [NAME],
    CAST(NULL AS nvarchar(255)) AS [CUSTOMER_GROUP_NO]
from cus.Customers
