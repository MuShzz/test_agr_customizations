CREATE VIEW [cus].v_OPEN_SALES_ORDER AS

	SELECT
		CAST(cso.SalesOrderCode AS nvarchar(128))                               AS [SALES_ORDER_NO],
		CAST(csod.ItemCode AS nvarchar(255))                                    AS [ITEM_NO],
		CAST(csod.WarehouseCode AS nvarchar(255))                               AS [LOCATION_NO],
		CAST(SUM(csod.QuantityOrdered*csod.UnitMeasureQty) AS decimal(18,4))    AS [QUANTITY],
		CAST(cso.BillToCode AS nvarchar(255))                                   AS [CUSTOMER_NO],
        CAST(CASE WHEN fos.SLADate is null or fos.SLADate< '2000-01-01' OR fos.SLADate= '' then getdate()
                  WHEN cso.MaxoptraETA_C is null then fos.SLADate
                  ELSE getdate() end
            AS date)                                                               AS [DELIVERY_DATE]
	FROM cus.CustomerSalesOrder cso
		INNER JOIN cus.CustomerSalesOrderDetail csod                ON csod.SalesOrderCode = cso.SalesOrderCode
		LEFT JOIN cus.ForemostOpenOrderSendableAndSLAStatus fos     ON fos.SalesOrderCode=cso.SalesOrderCode
	    inner join core.location_mapping_setup lms                      on lms.locationNo=csod.WarehouseCode
	WHERE cso.Type IN ('Sales Order','Back Order')
		AND cso.OrderStatus='Open'
		AND cso.IsVoided=0
	--and cso.SalesOrderCode in ('SO-273290', 'SO-273929','SO-273973')
	GROUP BY
		cso.SalesOrderCode,
		csod.ItemCode,
		csod.WarehouseCode,
		cso.BillToCode,
        CAST(CASE WHEN fos.SLADate is null or fos.SLADate< '2000-01-01' OR fos.SLADate= '' then getdate()
                  WHEN cso.MaxoptraETA_C is null then fos.SLADate
                  ELSE getdate() end
            AS date)
	HAVING SUM(csod.QuantityOrdered*csod.UnitMeasureQty)<>0
			AND CAST(CASE WHEN fos.SLADate is null or fos.SLADate< '2000-01-01' OR fos.SLADate= '' then getdate()
                          WHEN cso.MaxoptraETA_C is null then fos.SLADate
                          ELSE getdate() end
        AS date) IS NOT NULL
