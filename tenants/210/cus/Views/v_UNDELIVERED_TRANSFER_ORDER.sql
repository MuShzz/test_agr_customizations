CREATE VIEW [cus].v_UNDELIVERED_TRANSFER_ORDER AS
    SELECT
       CAST(istr.TransferCode AS varchar(128))              AS [TRANSFER_ORDER_NO],
       CAST(istrd.ItemCode AS nvarchar(255))                AS [ITEM_NO],
       CAST(istr.WarehouseCodeRequest AS nvarchar(255))     AS [LOCATION_NO],
       CAST(istr.WarehouseCodeSource AS nvarchar(255))      AS [ORDER_FROM_LOCATION_NO],
       CAST(istr.TransferDate AS date)                      AS [DELIVERY_DATE],
       CAST(sum(istrd.Quantity) AS decimal(18,4))           AS [QUANTITY]
    from cus.InventoryStockTransferRequest istr 
        inner join cus.InventoryStockTransferRequestDetail istrd    on istrd.TransferCode=istr.TransferCode
        inner join core.location_mapping_setup lms_to               on lms_to.locationNo=istr.WarehouseCodeRequest
        inner join core.location_mapping_setup lms_from             on lms_from.locationNo=istr.WarehouseCodeSource
    where 
        istr.Status not in ('Void','Complete')
    group by 
        istr.TransferCode, istrd.ItemCode, istr.WarehouseCodeRequest, istr.WarehouseCodeSource, istr.TransferDate
