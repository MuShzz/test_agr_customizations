-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Purchase order mapping from sage200 to adi format
--
-- 10.01.2025.TO    Created
-- ===============================================================================
CREATE VIEW [sage200_sql_cus].[v_PURCHASE_ORDER_ROUTE]
AS
            SELECT
                CAST(pv.[code] AS NVARCHAR(255))                AS [ITEM_NO],
                CAST(wh.[warehouse_name] AS NVARCHAR(255))      AS [LOCATION_NO],
                CAST(sv.[reference] AS NVARCHAR(255))           AS [VENDOR_NO],
                CAST([is_preferred] AS BIT)                     AS [PRIMARY],
                sage200_sql.LeadTimeConvert(ps.[lead_time_unit],ps.lead_time) AS [LEAD_TIME_DAYS],
                CAST(NULL AS SMALLINT)                          AS [ORDER_FREQUENCY_DAYS],
                CAST(ps.[minimum_order_quantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],    -- Return NULL if value 0.0
                CAST(pv.[average_buying_price] AS DECIMAL(18,4)) AS [COST_PRICE],
                CAST(ps.[list_price] AS DECIMAL(18,4))          AS [PURCHASE_PRICE],
                CAST(NULL AS DECIMAL(18,4))                     AS [ORDER_MULTIPLE],   -- Return NULL if value 0.0
                CAST(NULL AS DECIMAL(18,4))                     AS [QTY_PALLET]
            FROM [sage200_sql].[v_product_suppliers] ps
                INNER JOIN [sage200_sql].[v_product_views] pv ON pv.id = ps.[product_id]
                INNER JOIN [sage200_sql].[v_warehouse_holdings] wh ON pv.id = wh.[product_id]
                INNER JOIN [sage200_sql].[v_supplier_views] sv ON sv.id = ps.supplier_id

