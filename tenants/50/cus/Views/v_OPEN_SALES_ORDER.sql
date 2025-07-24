CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
       SELECT
            CAST(so.[tranid] AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(so.[item_code] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(so.[location_name] AS NVARCHAR(255)) AS [LOCATION_NO],
            SUM(CAST(-(so.[quantity]+so.[quantityshiprecv]) AS DECIMAL(18,4)) / ISNULL(CAST(uom.conversionrate AS DECIMAL(18,4)),1)) AS [QUANTITY],
            CAST(c.[entityid] AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(CONVERT(DATE, so.[expectedshipdate], 103) AS DATE) AS [DELIVERY_DATE]
        FROM [cus].[SalesOrders] so
		LEFT JOIN [cus].[Customer] c ON so.entity = c.id
		INNER JOIN [cus].[Item] i ON so.[item_code] = i.itemid
	    LEFT JOIN [cus].[Unitstypeuom] uom ON i.purchaseunit_id = uom.internalid
        WHERE so.dropship <> 'T'
		GROUP BY so.[tranid],so.[item_code],so.[location_name],so.[expectedshipdate], c.[entityid]
