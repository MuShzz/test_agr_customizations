CREATE VIEW [cus].[v_TRANSFER_HISTORY] AS
       SELECT
            CAST(ROW_NUMBER() OVER (ORDER BY h.pkTransferId, l.fkStockItemId) AS BIGINT) AS [TRANSACTION_ID],
            CAST(si.ItemNumber AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(sl1.Location AS NVARCHAR(255)) AS [FROM_LOCATION_NO],
            CAST(sl2.Location AS NVARCHAR(255)) AS [TO_LOCATION_NO],
            CAST(CONVERT(DATE,h.OrderDate, 103) AS DATE) AS [DATE],
            CAST(l.RequestedQuantity AS DECIMAL(18, 4)) AS [TRANSFER]
       FROM cus.TransferOrdersHeaders h
	   INNER JOIN cus.TransferOrdersLines l
	   ON h.pkTransferId = l.fkTransferId
	   AND h.Status = 'Delivered'
	   AND h.bLogicalDelete = 'False'
	   INNER JOIN cus.StockItem si 
	   ON si.pkStockItemID = l.fkStockItemId
	   INNER JOIN cus.StockLocation sl1
	   ON sl1.pkStockLocationId = h.fkFromLocationId
	   INNER JOIN cus.StockLocation sl2
	   ON sl2.pkStockLocationId = h.fkToLocationId
