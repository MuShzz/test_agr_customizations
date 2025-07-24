

CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST(cd_id AS NVARCHAR(255)) AS [no],
        CAST(cd_statement_name AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO]
    FROM cus.Customer


