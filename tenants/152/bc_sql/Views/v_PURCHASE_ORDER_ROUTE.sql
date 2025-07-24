-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Purchase order route mapping from BC
--
--  24.10.2024.BF   Created
-- ===============================================================================
CREATE VIEW [bc_sql_cus].[v_PURCHASE_ORDER_ROUTE]
AS

    SELECT
        CAST(i.No_ AS NVARCHAR(255)) AS [item_no],
        CAST(sku.Location AS NVARCHAR(255)) AS [location_no],
        CAST(sku.Supplier AS NVARCHAR(255)) AS [vendor_no],
        CAST(1 AS BIT) AS [primary],
        CAST(sku.[AGR Lead time] AS SMALLINT) AS [lead_time_days],
        CAST(NULL AS SMALLINT) AS [order_frequency_days],
        CAST(sku.[Minimum Order Quantity] AS DECIMAL(18,4)) AS [min_order_qty],    -- Return NULL if value 0.0
        CAST(NULL AS DECIMAL(18,4)) AS [cost_price],
        CAST(NULL AS DECIMAL(18,4)) AS [purchase_price],
        CAST(NULL AS DECIMAL(18,4)) AS [order_multiple],   -- Return NULL if value 0.0
        CAST(NULL AS DECIMAL(18,4)) AS [qty_pallet]
    FROM
		bc_sql.Item i
		LEFT JOIN bc_sql_cus.OCAGRSKU sku ON sku.[Item No_]=i.No_
		INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.Location
	WHERE sku.[Order From Type]=0 --Order from type = 0 is selected when items are supposed to be ordered from supplier, not warehouse

