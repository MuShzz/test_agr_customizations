CREATE VIEW [cus].v_CUSTOMER AS

	SELECT
		CAST(c.CustomerCode AS nvarchar(255))                           AS [NO],
		CAST(c.CustomerName AS nvarchar(255))                           AS [NAME],
		CAST(ISNULL(c.CustomerTier_C,'Unassigned') AS nvarchar(255))    AS [CUSTOMER_GROUP_NO]
	FROM cus.Customer c
	WHERE c.IsActive=1
