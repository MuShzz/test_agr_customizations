CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
       SELECT
            CASE WHEN v.[entityid] IS NOT NULL THEN
                CAST(po.[tranid]+'-'+v.[entityid]+'-'+po.[location_name] AS NVARCHAR(128))
            ELSE
                CAST(po.[tranid]+'-'+po.[location_name] AS NVARCHAR(128))
            END AS [PURCHASE_ORDER_NO],
            CAST(po.[item_code] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(po.[location_name] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(MAX(CONVERT(DATE,ISNULL(po.[expectedreceiptdate],po.[duedate]), 103)) AS DATE) AS [DELIVERY_DATE],
            SUM(CAST(po.[quantity]-po.quantityshiprecv AS DECIMAL(18,4)) / ISNULL(CAST(uom.conversionrate AS DECIMAL(18,4)),1)) AS [QUANTITY]
     FROM [cus].[PurchaseOrders] po
	 INNER JOIN [cus].[Item] i ON po.[item_code] = i.itemid
	 LEFT JOIN [cus].[Unitstypeuom] uom ON i.purchaseunit_id = uom.internalid
     LEFT JOIN [cus].[Vendor] v ON po.entity = v.id
     where po.dropship <> 'T'
     GROUP BY po.[tranid],v.[entityid],po.[location_name],v.entityid,po.[item_code],po.[expectedreceiptdate],po.[duedate]
	 HAVING CAST(SUM(po.[quantity]-po.quantityshiprecv) AS DECIMAL(18,4)) <> 0
