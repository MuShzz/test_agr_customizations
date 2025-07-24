CREATE VIEW [cus].v_PURCHASE_ORDER_RECEIVED_HISTORY AS
    SELECT
       CAST(SPRD.OriginalDocumentCode AS varchar(128)) AS [PURCHASE_ORDER_NO],
       CAST(NULL AS varchar(128)) AS [AGR_ORDER_ID],
       CAST(SPRD.ItemCode AS nvarchar(255)) AS [ITEM_NO],
       CAST(SPRD.WarehouseCode AS nvarchar(255)) AS [LOCATION_NO],
       CAST(spr.SupplierCode AS nvarchar(255)) AS [VENDOR_NO],
       CAST(spo.PODate AS date) AS [ORDER_DATE],
       CAST(SPR.PRDate AS date) AS [DELIVERY_DATE],
       CAST(sum(spod.QuantityOrdered) AS decimal(18,4)) AS [ORDERED_QTY],
       CAST(sum(SPRD.QuantityReceived) AS decimal(18,4)) AS [DELIVERED_QTY],
       CAST(NULL AS decimal(18,4)) AS [PURCHASE_PRICE],
       CAST(NULL AS int) AS [LEAD_TIME_CALCULATION_DAYS]
    from cus.SupplierPurchaseReceipt SPR
        inner join cus.SupplierPurchaseReceiptDetail SPRD   on sprd.PurchaseReceiptCode=spr.PurchaseReceiptCode
        inner join cus.SupplierPurchaseOrderDetail spod     on spod.PurchaseOrderCode=SPRD.OriginalDocumentCode 
                                                                   and spod.ItemCode=SPRD.ItemCode 
                                                                   and spod.WarehouseCode=sprd.WarehouseCode
        inner join cus.SupplierPurchaseOrder spo            on spo.PurchaseOrderCode=spod.PurchaseOrderCode
        inner join core.location_mapping_setup lms          on lms.locationNo=sprd.WarehouseCode
    where SPR.IsVoided=0
    group by SPRD.OriginalDocumentCode, SPRD.ItemCode, SPRD.WarehouseCode, spr.SupplierCode, spo.PODate, SPR.PRDate
