CREATE VIEW [cus].v_CUSTOMER_GROUP AS
	
	SELECT DISTINCT
		CAST(ISNULL(c.CustomerTier_C,'Unassigned') AS nvarchar(255)) AS [NO],
		CAST(ISNULL(c.CustomerTier_C,'Unassigned') AS nvarchar(255)) AS [NAME]
	FROM cus.Customer c
	WHERE c.IsActive=1


