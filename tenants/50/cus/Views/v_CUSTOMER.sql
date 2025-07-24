

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================

CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST([entityid] AS NVARCHAR(255)) AS [no],
        CAST(COALESCE([companyname],[altname],[entitytitle]) AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO]
    FROM [cus].[Customer]
    WHERE [isinactive] = 'F'

