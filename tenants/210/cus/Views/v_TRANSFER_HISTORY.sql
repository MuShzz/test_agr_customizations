CREATE VIEW [cus].v_TRANSFER_HISTORY AS

    SELECT
        CAST(NULL AS bigint)                            AS [TRANSACTION_ID],
        CAST(istd.ItemCode AS nvarchar(255))            AS [ITEM_NO],
        CAST(ist.WarehouseCodeSource AS nvarchar(255))  AS [FROM_LOCATION_NO],
        CAST(ist.WarehouseCodeDest AS nvarchar(255))    AS [TO_LOCATION_NO],
        CAST(ist.TransferDate AS date)                  AS [DATE],
        CAST(SUM(istd.Quantity) AS decimal(18,4))       AS [TRANSFER]
     from cus.InventoryStockTransferDetail istd
		inner join cus.InventoryStockTransfer ist   on istd.TransferCode = ist.TransferCode
        inner join core.location_mapping_setup lms_to on lms_to.locationNo=ist.WarehouseCodeDest
        inner join core.location_mapping_setup lms_from on lms_from.locationNo=ist.WarehouseCodeSource
	where ist.WarehouseCodeDest<>ist.WarehouseCodeSource
	GROUP BY istd.ItemCode,
		ist.WarehouseCodeDest,
		ist.WarehouseCodeSource,
		ist.TransferDate
