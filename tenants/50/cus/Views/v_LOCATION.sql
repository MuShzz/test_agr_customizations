

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST([Name] AS NVARCHAR(255)) AS [NO],
            CAST([fullname] AS NVARCHAR(255)) AS [NAME]
       FROM
            [cus].[Location]

