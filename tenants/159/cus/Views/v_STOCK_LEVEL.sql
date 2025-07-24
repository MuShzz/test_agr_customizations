CREATE VIEW [cus].[v_STOCK_LEVEL] AS
        SELECT
            CAST(si.ItemNumber AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(sll.Location AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS [EXPIRE_DATE],
            SUM(CAST(sl.Quantity AS DECIMAL(18, 4))) AS [STOCK_UNITS]
       FROM cus.StockLevels sl
	   INNER JOIN cus.StockItem si 
	   ON si.pkStockItemID = sl.fkStockItemId
	   INNER JOIN cus.StockLocation sll
	   ON sll.pkStockLocationId = sl.fkStockLocationId
	   WHERE si.pkStockItemID NOT IN (SELECT pkStockItemId FROM cus.StockItemComposition)
GROUP BY si.ItemNumber, sll.Location
