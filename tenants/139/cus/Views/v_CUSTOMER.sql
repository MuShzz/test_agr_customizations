
CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST('agr_no_customer' AS NVARCHAR(255)) AS [no],
        CAST('N/A' AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO],
        CAST(NULL AS CHAR(3)) AS Company
    
	UNION

	SELECT
        CAST(c.[No] AS NVARCHAR(255)) AS [no],
        CAST(c.[Name] AS NVARCHAR(255)) AS [name],
        CAST(ci.GlobalDimension1Code AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO],
        c.Company
	FROM
        [cus].customer c
		INNER JOIN cus.customer_extra_info ci ON ci.No=c.No


