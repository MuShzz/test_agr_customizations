CREATE VIEW [ax_cus].[v_CUSTOMER] 
AS
	
	WITH CombinedCustomers AS (
		SELECT 
			CAST(c.ACCOUNTNUM AS NVARCHAR(255)) AS [no],
			CAST(c.NAME AS NVARCHAR(255))       AS [name],
			CAST(c.DATAAREAID AS NVARCHAR(4))   AS [COMPANY],
			CAST(NULL AS NVARCHAR(255))         AS [CUSTOMER_GROUP_NO]
		FROM 
			[ax].CUSTOMERVIEW c

		UNION ALL

		SELECT 
			CAST(c.ACCOUNTNUM AS NVARCHAR(255)) AS [no],
			CAST(c.NAME AS NVARCHAR(255))       AS [name],
			CAST(c.DATAAREAID AS NVARCHAR(4))   AS [COMPANY],
			CAST(NULL AS NVARCHAR(255))         AS [CUSTOMER_GROUP_NO]
		FROM 
			[ax_cus].Customer_nor_sve c
	),
	RankedCustomers AS (
		SELECT *,
			   ROW_NUMBER() OVER (
				   PARTITION BY [no]
				   ORDER BY CASE WHEN [COMPANY] = 'the' THEN 0 ELSE 1 END
			   ) AS rn
		FROM CombinedCustomers
	)
	SELECT 
		[no], 
		[name], 
		'the' AS [COMPANY], 
		[CUSTOMER_GROUP_NO]
	FROM 
		RankedCustomers
	WHERE 
		rn = 1


