

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST([entityid] AS NVARCHAR(255)) AS [NO],
            CAST(ISNULL(NULLIF([companyname],''), [altname]) AS NVARCHAR(255)) AS [NAME],
            CAST(ISNULL([predicteddays],1) AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(IIF([isinactive] = 'F',0,1) AS BIT) AS [CLOSED]
       FROM
        [cus].[Vendor]


