CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
	SELECT
		CAST(h.pkOrderID AS NVARCHAR(128))				AS [SALES_ORDER_NO],
		CAST(si.ItemNumber AS NVARCHAR(255))			AS [ITEM_NO],
		CAST(sl.Location AS NVARCHAR(255))				AS [LOCATION_NO],
		SUM(CAST(l.nQty AS DECIMAL(18, 4)))				AS [QUANTITY],
		CAST(CASE WHEN h.SubSource = 'Aspire Furniture'
				 THEN 'Amazon'
				 ELSE h.SubSource END AS NVARCHAR(255))	AS [CUSTOMER_NO],
		CAST(CONVERT(DATE, h.dDispatchBy, 103) AS DATE) AS [DELIVERY_DATE]
	FROM cus.Open_Order h
		INNER JOIN cus.Open_OrderItem l
		ON h.pkOrderID = l.fkOrderID
		AND l.fkStockItemId <> 'NULL'
		INNER JOIN cus.StockItem si
		ON si.pkStockItemID = L.fkStockItemId
		INNER JOIN cus.StockLocation sl
		ON sl.pkStockLocationId = h.FulfillmentLocationId
	WHERE NOT EXISTS (
        SELECT 1
        FROM cus.Stock_ItemComposition comp
        INNER JOIN cus.Open_OrderItem parent_oi
            ON comp.pkStockItemId = parent_oi.fkStockItemId
        WHERE
            comp.pkLinkStockItemId = l.fkStockItemId  -- current item is a child
            AND parent_oi.fkOrderID = l.fkOrderID     -- parent is in same order
    )
	GROUP BY h.pkOrderID, si.ItemNumber, sl.Location, CAST(CONVERT(DATE, h.dDispatchBy, 103) AS DATE),h.cFullName, h.cEmailAddress, h.SubSource
	HAVING SUM(CAST(l.nQty AS DECIMAL(18, 4)))<>0

