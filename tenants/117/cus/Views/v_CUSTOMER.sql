



-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Customer mapping from raw to adi
--
--  24.09.2024.TO   Altered
-- ===============================================================================

CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST([CustID] AS NVARCHAR(255)) AS [no],
        CAST([Name] AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO]
    FROM cus.Customer


