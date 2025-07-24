CREATE VIEW [cus].[v_BOM_CONSUMPTION_HISTORY] AS
    SELECT
        CAST(ROW_NUMBER() OVER(ORDER BY h.pkOrderID) AS BIGINT)	AS TRANSACTION_ID,
        CAST(si.ItemNumber AS NVARCHAR(255))					AS ITEM_NO,
        CAST(sl.Location AS NVARCHAR(255))						AS LOCATION_NO,
        CAST(CONVERT(DATE, h.dDispatchBy, 103) AS DATE)         AS [DATE],
        CAST(CAST(l.nQty AS DECIMAL(18,4)) * 
		CAST(sc.Quantity AS DECIMAL(18,4)) AS DECIMAL(18,4))	AS [UNIT_QTY]
    FROM cus.SalesOrdersHeaders h
	INNER JOIN cus.SalesOrdersLines l
	ON h.pkOrderID = l.fkOrderID
	INNER JOIN cus.StockItemComposition sc
	ON l.fkStockItemId = sc.pkStockItemId
	INNER JOIN cus.StockLocation sl
	ON l.fkLocationId = sl.pkStockLocationId
	INNER JOIN cus.StockItem si
	ON si.pkStockItemID = sc.pkLinkStockItemId

