CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT DISTINCT
        CAST(SubSource AS NVARCHAR(255)) AS [no],
        CAST(SubSource AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255))			AS [customer_group_no]
    FROM cus.Open_Order

	UNION

	SELECT DISTINCT
        CAST(SubSource AS NVARCHAR(255)) AS [no],
        CAST(SubSource AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255))			AS [customer_group_no]
    FROM cus.[Order]


