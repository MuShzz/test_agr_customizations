CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
       SELECT
            CAST(h.pkTransferId AS VARCHAR(128)) AS [TRANSFER_ORDER_NO],
            CAST(si.ItemNumber AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(sl1.Location AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(GETDATE() AS DATE) AS [DELIVERY_DATE],
            CAST(l.RequestedQuantity AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(sl2.Location AS NVARCHAR(255)) AS [ORDER_FROM_LOCATION_NO]
       FROM cus.Warehouse_Transfer h
	   INNER JOIN cus.Warehouse_TransferItem l
	   ON h.pkTransferId = l.fkTransferId
	   AND h.Status <> 'Delivered'
	   AND h.bLogicalDelete = 'False'
	   INNER JOIN cus.StockItem si
	   ON si.pkStockItemID = l.fkStockItemId
	   INNER JOIN cus.StockLocation sl1
	   ON sl1.pkStockLocationId = h.fkToLocationId
	   INNER JOIN cus.StockLocation sl2
	   ON sl2.pkStockLocationId = h.fkFromLocationId
