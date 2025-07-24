

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Orderwise
--
--  24.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST(sl_id AS NVARCHAR(255)) AS [NO],
            CAST(sl_name AS NVARCHAR(255)) AS [NAME]
       FROM cus.stock_location


