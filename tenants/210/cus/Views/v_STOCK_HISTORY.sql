CREATE VIEW [cus].v_STOCK_HISTORY AS
    
    with all_stock_history as (
        --customer invoices
        SELECT
            CAST(NULL AS bigint)                                                    AS [TRANSACTION_ID],
            CAST(cid.ItemCode AS nvarchar(255))                                     AS [ITEM_NO],
            CAST(cid.WarehouseCode AS nvarchar(255))                                AS [LOCATION_NO],
            CAST(ci.InvoiceDate AS date)                                            AS [DATE],
            CAST(CASE WHEN ci.Type='Credit Memo'
                          THEN SUM(-cid.QuantityShipped*cid.UnitMeasureQty)
                      ELSE SUM(cid.QuantityShipped*cid.UnitMeasureQty) END
                AS decimal(18,4))                                                   AS [STOCK_MOVE],
            CAST(NULL AS decimal(18,4))                                             AS [STOCK_LEVEL]
        FROM cus.CustomerInvoice ci
            INNER JOIN cus.CustomerInvoiceDetail cid        ON cid.InvoiceCode=ci.InvoiceCode
            INNER JOIN core.location_mapping_setup lms      ON lms.locationNo=cid.WarehouseCode
        WHERE ci.IsVoided<>1 --excluding voided sales
        GROUP BY
            cid.ItemCode,
            cid.WarehouseCode,
            ci.InvoiceDate,
            ci.Type
        
        union all
        -- Supplier Goods Receipts
        SELECT
            CAST(NULL AS bigint)                                                    AS [TRANSACTION_ID],
            CAST(sprd.ItemCode AS nvarchar(255))                                    AS [ITEM_NO],
            CAST(sprd.WarehouseCode AS nvarchar(255))                               AS [LOCATION_NO],
            CAST(spr.PRDate AS date)                                                AS [DATE],
            CAST(sum(sprd.QuantityReceived) AS decimal(18,4))                       AS [STOCK_MOVE],
            CAST(NULL AS decimal(18,4))                                             AS [STOCK_LEVEL]
        FROM cus.SupplierPurchaseReceipt spr
                 INNER JOIN cus.SupplierPurchaseReceiptDetail sprd        ON sprd.PurchaseReceiptCode=spr.PurchaseReceiptCode
                 INNER JOIN core.location_mapping_setup lms      ON lms.locationNo=sprd.WarehouseCode
        WHERE spr.IsVoided=0 --excluding voided sales
        GROUP BY
            sprd.ItemCode,
            sprd.WarehouseCode,
            spr.PRDate

        union all
        -- Adjustments in or out of a warehouse
        SELECT
            CAST(NULL AS bigint)                                           AS [TRANSACTION_ID],
            CAST(iad.ItemCode AS nvarchar(255))                            AS [ITEM_NO],
            CAST(iad.WarehouseCode AS nvarchar(255))                       AS [LOCATION_NO],
            CAST(ia.TransactionDate AS date)                               AS [DATE],
            CAST(sum(iad.Quantity) AS decimal(18,4))                       AS [STOCK_MOVE],
            CAST(NULL AS decimal(18,4))                                    AS [STOCK_LEVEL]
        FROM cus.InventoryAdjustment ia
                 INNER JOIN cus.InventoryAdjustmentDetail iad    ON iad.AdjustmentCode=ia.AdjustmentCode
                 INNER JOIN core.location_mapping_setup lms      ON lms.locationNo=iad.WarehouseCode
        WHERE ia.IsVoided=0 --excluding voided sales
        and ia.AdjustmentType='In'
        GROUP BY
            iad.ItemCode,
            iad.WarehouseCode,
            ia.TransactionDate,iad.AdjustmentCode
        
        union all
        SELECT
            CAST(NULL AS bigint)                                            AS [TRANSACTION_ID],
            CAST(iad.ItemCode AS nvarchar(255))                             AS [ITEM_NO],
            CAST(iad.WarehouseCode AS nvarchar(255))                        AS [LOCATION_NO],
            CAST(ia.TransactionDate AS date)                                AS [DATE],
            CAST(sum(-iad.Quantity) AS decimal(18,4))                       AS [STOCK_MOVE],
            CAST(NULL AS decimal(18,4))                                     AS [STOCK_LEVEL]
        FROM cus.InventoryAdjustment ia
                 INNER JOIN cus.InventoryAdjustmentDetail iad    ON iad.AdjustmentCode=ia.AdjustmentCode
                 INNER JOIN core.location_mapping_setup lms      ON lms.locationNo=iad.WarehouseCode
        WHERE ia.IsVoided=0 --excluding voided sales
          and ia.AdjustmentType='Out'
        GROUP BY
            iad.ItemCode,
            iad.WarehouseCode,
            ia.TransactionDate
        
        
        union all
        -- transfers between warehouses
        SELECT
            CAST(NULL AS bigint)                            AS [TRANSACTION_ID],
            CAST(istd.ItemCode AS nvarchar(255))            AS [ITEM_NO],
            CAST(ist.WarehouseCodeSource AS nvarchar(255))  AS [LOCATION_NO],
            CAST(ist.TransferDate AS date)                  AS [DATE],
            CAST(SUM(-istd.Quantity) AS decimal(18,4))       AS [STOCK_MOVE],
            CAST(NULL AS decimal(18,4))                     AS [STOCK_LEVEL]
        from cus.InventoryStockTransferDetail istd
                 inner join cus.InventoryStockTransfer ist   on istd.TransferCode = ist.TransferCode
                 INNER JOIN core.location_mapping_setup lms  ON lms.locationNo=ist.WarehouseCodeSource
        where ist.WarehouseCodeDest<>ist.WarehouseCodeSource
        GROUP BY istd.ItemCode,
                 ist.WarehouseCodeSource,
                 ist.TransferDate
        union all
        SELECT
            CAST(NULL AS bigint)                            AS [TRANSACTION_ID],
            CAST(istd.ItemCode AS nvarchar(255))            AS [ITEM_NO],
            CAST(ist.WarehouseCodeDest AS nvarchar(255))    AS [LOCATION_NO],
            CAST(ist.TransferDate AS date)                  AS [DATE],
            CAST(SUM(istd.Quantity) AS decimal(18,4))       AS [STOCK_MOVE],
            CAST(NULL AS decimal(18,4))                     AS [STOCK_LEVEL]
        from cus.InventoryStockTransferDetail istd
                 inner join cus.InventoryStockTransfer ist   on istd.TransferCode = ist.TransferCode
                 INNER JOIN core.location_mapping_setup lms  ON lms.locationNo=ist.WarehouseCodeDest
        where ist.WarehouseCodeDest<>ist.WarehouseCodeSource
        GROUP BY istd.ItemCode,
                 ist.WarehouseCodeDest,
                 ist.TransferDate

    )
    SELECT
       CAST(NULL AS bigint) AS [TRANSACTION_ID],
       CAST(ash.ITEM_NO AS nvarchar(255)) AS [ITEM_NO],
       CAST(ash.LOCATION_NO AS nvarchar(255)) AS [LOCATION_NO],
       CAST(ash.DATE AS date) AS [DATE],
       CAST(sum(ash.STOCK_MOVE) AS decimal(18,4)) AS [STOCK_MOVE],
       CAST(ash.STOCK_LEVEL AS decimal(18,4)) AS [STOCK_LEVEL]
    from all_stock_history ash
        inner join core.location_mapping_setup lms on lms.locationNo=ash.LOCATION_NO
    group by 
        ash.ITEM_NO,
        ash.LOCATION_NO,
        ash.DATE,
        ash.STOCK_LEVEL
    having ash.DATE is not null
