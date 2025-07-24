CREATE VIEW [cus].v_UNDELIVERED_PURCHASE_ORDER AS

    SELECT
        CAST(spo.PurchaseOrderCode AS nvarchar(128))                                                         AS [PURCHASE_ORDER_NO],
        CAST(spod.ItemCode AS nvarchar(255))                                                                AS [ITEM_NO],
        CAST(spod.WarehouseCode AS nvarchar(255))                                                           AS [LOCATION_NO],
        CAST(
            IIF(spo.podate >= spod.duedate,
                IIF(
                    isp.LeadTime IS NOT NULL OR s.LeadTimeCalendarDays_C IS NOT NULL,
                    DATEADD(DAY,ISNULL(isp.LeadTime, s.LeadTimeCalendarDays_C),spod.DueDate),
                    GETDATE()
                ),
                spod.DueDate
            ) AS date
        ) AS [DELIVERY_DATE],
        CAST(SUM((spod.QuantityOrdered-spod.QuantityReceived)*spod.UnitMeasureQty) AS decimal(18,4))        AS [QUANTITY]
    FROM cus.SupplierPurchaseOrder spo
		INNER JOIN cus.SupplierPurchaseOrderDetail spod     ON spod.PurchaseOrderCode=spo.PurchaseOrderCode
		LEFT JOIN cus.InventorySupplier isp                 ON spod.ItemCode=isp.ItemCode AND spo.SupplierCode=isp.SupplierCode AND isp.WarehouseCode=spod.WarehouseCode
        left join cus.Supplier S                            on s.SupplierCode=spo.SupplierCode
		INNER JOIN core.location_mapping_setup lms          ON lms.locationNo=spod.WarehouseCode
	WHERE spo.OrderStatus NOT IN ('Completed')
		AND spo.IsVoided=0
		AND spo.IsProcessed=0
		and spod.QuantityReceived < spod.QuantityOrdered 
	    --and spo.PurchaseOrderCode='PO-136226'
	GROUP BY
		spo.PurchaseOrderCode,
		spod.ItemCode,
		spod.WarehouseCode,
        CAST(
                IIF(spo.podate >= spod.duedate,
                    IIF(
                            isp.LeadTime IS NOT NULL OR s.LeadTimeCalendarDays_C IS NOT NULL,
                            DATEADD(DAY,ISNULL(isp.LeadTime, s.LeadTimeCalendarDays_C),spod.DueDate),
                            GETDATE()
                    ),
                    spod.DueDate
                ) AS date)
