CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST(pkCustomerId AS NVARCHAR(255)) AS [no],
        CAST(
        CASE 
            WHEN Name = '' THEN Email 
            ELSE Name 
        END AS NVARCHAR(255)
									)		AS [name],
        CAST(NULL AS NVARCHAR(255))			AS [customer_group_no]
    FROM cus.Customers
	WHERE 1=0
