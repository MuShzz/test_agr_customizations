

-- ===============================================================================
-- Author:      Jose, Jose e Paulo
-- Description: Stock level mapping
--
-- 20.09.2024.TO    Created
-- ===============================================================================

    CREATE VIEW [cus].[v_STOCK_LEVEL] AS
       SELECT
            CAST(vsl_vad_id AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(vsl_sl_id AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS EXPIRE_DATE,
            CAST(vsl_overall_stock_quantity AS DECIMAL(18, 4)) AS [STOCK_UNITS]
       FROM cus.Stock_Level


