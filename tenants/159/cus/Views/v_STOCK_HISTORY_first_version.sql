    CREATE VIEW [cus].[v_STOCK_HISTORY_first_version]
AS
WITH cte AS
(
    SELECT 
        CAST(si.ItemNumber AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(sl.Location     AS NVARCHAR(255)) AS [LOCATION_NO],
        CAST(CONVERT(DATE, h.QuotedDeliveryDate, 103) AS DATE) AS [DATE],
        CAST(l.Quantity AS DECIMAL(18,4))         AS [STOCK_MOVE],
        CAST(NULL AS DECIMAL(18,4))              AS [STOCK_LEVEL]
    FROM cus.PurchaseOrdersHeaders h
    INNER JOIN cus.PurchaseOrdersLines l
        ON l.fkPurchasId = h.pkPurchaseID
	INNER JOIN cus.StockItem si
		ON si.pkStockItemID = l.fkStockItemId
	INNER JOIN cus.StockLocation sl
		ON sl.pkStockLocationId = h.fkLocationId
    WHERE h.Status = 'DELIVERED'
    
    UNION ALL

    SELECT 
        CAST(si.ItemNumber      AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(sl.Location AS NVARCHAR(255)) AS [LOCATION_NO],
        CAST(CONVERT(DATE, h.dDispatchBy, 103) AS DATE) AS [DATE],
        -CAST(l.nQty AS DECIMAL(18,4)) AS [STOCK_MOVE],
        CAST(NULL     AS DECIMAL(18,4)) AS [STOCK_LEVEL]
    FROM cus.SalesOrdersHeaders h
    INNER JOIN cus.SalesOrdersLines l
        ON h.pkOrderID = l.fkOrderID
		AND l.fkStockItemId <> 'NULL'
		INNER JOIN cus.StockItem si
	   ON si.pkStockItemID = L.fkStockItemId
	   INNER JOIN cus.StockLocation sl
	   ON sl.pkStockLocationId = h.FulfillmentLocationId
	   WHERE CAST(CONVERT(DATE, h.dDispatchBy, 103) AS DATE) > DATEFROMPARTS(2020,1,1)
        
    UNION ALL
    
    SELECT
        CAST(si.ItemNumber    AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(sl1.Location AS NVARCHAR(255)) AS [LOCATION_NO],
        CAST(CONVERT(DATE, h.OrderDate, 103) AS DATE) AS [DATE],
        -CAST(l.RequestedQuantity AS DECIMAL(18,4)) AS [STOCK_MOVE],
        CAST(NULL                AS DECIMAL(18,4))  AS [STOCK_LEVEL]
    FROM cus.TransferOrdersHeaders h
    INNER JOIN cus.TransferOrdersLines l 
        ON h.pkTransferId = l.fkTransferId
	INNER JOIN cus.StockItem si 
	   ON si.pkStockItemID = l.fkStockItemId
	   INNER JOIN cus.StockLocation sl1
	   ON sl1.pkStockLocationId = h.fkFromLocationId
    WHERE h.Status = 'Delivered'
      AND h.bLogicalDelete = 'False'
	  
    
    UNION ALL
    
    SELECT
        CAST(si.ItemNumber   AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(sl2.Location  AS NVARCHAR(255)) AS [LOCATION_NO],
        CAST(CONVERT(DATE, h.OrderDate, 103) AS DATE) AS [DATE],
        CAST(l.RequestedQuantity AS DECIMAL(18,4))    AS [STOCK_MOVE],
        CAST(NULL               AS DECIMAL(18,4))     AS [STOCK_LEVEL]
    FROM cus.TransferOrdersHeaders h
    INNER JOIN cus.TransferOrdersLines l 
        ON h.pkTransferId = l.fkTransferId
	INNER JOIN cus.StockItem si 
	   ON si.pkStockItemID = l.fkStockItemId
	   INNER JOIN cus.StockLocation sl2
	   ON sl2.pkStockLocationId = h.fkToLocationId
    WHERE h.Status = 'Delivered'
      AND h.bLogicalDelete = 'False'
)
SELECT
    
    ROW_NUMBER() OVER (
       ORDER BY 
          cte.ITEM_NO, cte.LOCATION_NO,cte.DATE     
    ) AS [TRANSACTION_ID],
    cte.ITEM_NO,
    cte.LOCATION_NO,
    cte.[DATE],
    cte.[STOCK_MOVE],
    cte.[STOCK_LEVEL]
FROM cte

