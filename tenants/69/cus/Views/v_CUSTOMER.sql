CREATE VIEW [cus].v_CUSTOMER
AS
SELECT CAST(NO AS nvarchar(255))   AS [NO],
       CAST(Name AS nvarchar(255)) AS [NAME],
       CAST(NULL AS nvarchar(255)) AS [CUSTOMER_GROUP_NO]
FROM cus.customer
