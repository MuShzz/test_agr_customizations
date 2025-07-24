

CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST([CustNo] AS NVARCHAR(255)) AS [no],
        CAST([Nm] AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO]
    FROM [cus].[Actor]
	WHERE CustNo <> 0

