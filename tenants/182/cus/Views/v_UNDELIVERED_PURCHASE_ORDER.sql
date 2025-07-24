 CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
       SELECT
            CAST(h.ExternalInvoiceNumber AS VARCHAR(128))															AS [PURCHASE_ORDER_NO],
            CAST(si.ItemNumber AS NVARCHAR(255))														AS [ITEM_NO],
            CAST(sl.Location AS NVARCHAR(255))															AS [LOCATION_NO],
            CAST(CONVERT(DATE, h.QuotedDeliveryDate, 103) AS DATE)												AS [DELIVERY_DATE],
            SUM(CAST(CAST(l.Quantity AS DECIMAL(18,4)) - CAST(l.Delivered AS DECIMAL(18,4)) AS DECIMAL(18, 4)))	AS [QUANTITY]
       FROM cus.Purchase h
	   INNER JOIN cus.PurchaseItem l
	   ON l.fkPurchasId = h.pkPurchaseID
	   AND h.Status <> 'DELIVERED'
	   INNER JOIN cus.StockItem si
	   ON si.pkStockItemID = l.fkStockItemId
	   INNER JOIN cus.StockLocation sl
	   ON sl.pkStockLocationId = h.fkLocationId
	   GROUP BY
		h.ExternalInvoiceNumber,
		si.ItemNumber,
		sl.Location,
		CAST(CONVERT(DATE, h.QuotedDeliveryDate, 103) AS DATE)
	HAVING SUM(CAST(CAST(l.Quantity AS DECIMAL(18,4)) - CAST(l.Delivered AS DECIMAL(18,4)) AS DECIMAL(18, 4)))>0

