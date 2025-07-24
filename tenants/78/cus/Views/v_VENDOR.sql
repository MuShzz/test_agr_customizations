

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Quick Books Desktop
--
--  23.09.2024.TO   Altered
-- ===============================================================================

    CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST(v.[ListID] AS NVARCHAR(255)) AS [NO],
            CAST(v.[Name] AS NVARCHAR(255)) AS [NAME],
            CAST(1 AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST([IsActive] AS BIT) ^ 1 AS [CLOSED]
       FROM
        [cus].[Vendor] v


