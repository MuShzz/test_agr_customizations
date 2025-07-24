CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
       
	SELECT
		CAST(h.pkPurchaseID AS VARCHAR(128))																	AS [PURCHASE_ORDER_NO],
		CAST(si.ItemNumber AS NVARCHAR(255))																	AS [ITEM_NO],
		CAST(sl.Location AS NVARCHAR(255))																		AS [LOCATION_NO],
		CAST(CONVERT(DATE, h.QuotedDeliveryDate, 103) AS DATE)													AS [DELIVERY_DATE],
		CAST(SUM(CAST(l.Quantity AS DECIMAL(18,4)) - CAST(l.Delivered AS DECIMAL(18,4))) AS DECIMAL(18, 4))		AS [QUANTITY]
	FROM cus.PurchaseOrdersHeaders h 
		INNER JOIN cus.PurchaseOrdersLines l ON l.fkPurchasId = h.pkPurchaseID AND h.Status <> 'DELIVERED'
		INNER JOIN cus.StockItem si	ON si.pkStockItemID = l.fkStockItemId
		INNER JOIN cus.StockLocation sl	ON sl.pkStockLocationId = h.fkLocationId
	GROUP BY h.pkPurchaseID, si.ItemNumber, sl.Location, CAST(CONVERT(DATE, h.QuotedDeliveryDate, 103) AS DATE)
	HAVING CAST(SUM(CAST(l.Quantity AS DECIMAL(18,4)) - CAST(l.Delivered AS DECIMAL(18,4))) AS DECIMAL(18, 4)) <>0


