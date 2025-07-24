CREATE VIEW [cus].[v_STOCK_HISTORY]
AS
SELECT
        ROW_NUMBER() OVER (
        ORDER BY 
            CAST(si.ItemNumber AS NVARCHAR(255)), 
            CAST(sl.Location AS NVARCHAR(255)), 
            CAST(CONVERT(DATETIME, sc.StockChangeDateTime, 103) AS DATE)
																				)	AS [TRANSACTION_ID],
        CAST(si.ItemNumber AS NVARCHAR(255))										AS [ITEM_NO],
        CAST(sl.Location AS NVARCHAR(255))											AS [LOCATION_NO],
        CAST(CONVERT(DATETIME, sc.StockChangeDateTime, 103) AS DATE)                AS [DATE],
        CAST(sc.ChangeQty AS DECIMAL(18,4))											AS [STOCK_MOVE],
        CAST(NULL AS DECIMAL(18,4))													AS [STOCK_LEVEL]
    FROM
        [cus].[StockChange] sc
		INNER JOIN cus.StockItem si ON sc.fkStockItemId = si.pkStockItemID
		INNER JOIN cus.StockLocation sl ON sc.fkStockLocationId = sl.pkStockLocationId
	WHERE si.pkStockItemID NOT IN (SELECT pkStockItemId FROM cus.StockItemComposition) 
