CREATE VIEW [fo_cus].[v_customer]
AS

    SELECT
        CAST(c.CUSTOMERACCOUNT AS NVARCHAR(255)) AS [no],
        CAST(c.ORGANIZATIONNAME AS NVARCHAR(255)) AS [name],
		CAST(NULL AS DECIMAL(18,4)) AS [CUSTOMER_GROUP_NO]
    FROM fo.[Customers] c

