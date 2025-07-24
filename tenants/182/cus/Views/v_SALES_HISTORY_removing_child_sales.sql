CREATE VIEW [cus].[v_SALES_HISTORY_removing_child_sales] AS
       SELECT
            CAST(
        ROW_NUMBER() OVER (
            ORDER BY l.fkStockItemId, h.FulfillmentLocationId) AS BIGINT)	AS [TRANSACTION_ID],
            CAST(si.ItemNumber AS NVARCHAR(255))							AS [ITEM_NO],
            CAST(sl.Location AS NVARCHAR(255))								AS [LOCATION_NO],
            CAST(CONVERT(DATE, h.dDispatchBy, 103) AS DATE)					AS [DATE],
            CAST(l.nQty AS DECIMAL(18, 4))									AS [SALE],
            CAST('' AS NVARCHAR(255))										AS [CUSTOMER_NO],
            CAST(h.ReferenceNum AS NVARCHAR(255))							AS [REFERENCE_NO],
            CAST(0 AS BIT)													AS [IS_EXCLUDED]
       FROM cus.[Order] h
	   INNER JOIN cus.OrderItem l
	   ON h.pkOrderID = l.fkOrderID
	   AND l.fkStockItemId <> 'NULL'
	   INNER JOIN cus.StockItem si
	   ON si.pkStockItemID = L.fkStockItemId
	   INNER JOIN cus.StockLocation sl
	   ON sl.pkStockLocationId = h.FulfillmentLocationId
	   WHERE CAST(CONVERT(DATE, h.dDispatchBy, 103) AS DATE) > DATEFROMPARTS(2020,1,1)
	   AND NOT EXISTS (
        SELECT 1
        FROM cus.Stock_ItemComposition comp
        INNER JOIN cus.OrderItem parent_oi
            ON comp.pkStockItemId = parent_oi.fkStockItemId
        WHERE
            comp.pkLinkStockItemId = l.fkStockItemId  -- current item is a child
            AND parent_oi.fkOrderID = l.fkOrderID     -- parent is in same order
    )

