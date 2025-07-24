



-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_SALES_HISTORY] AS
       SELECT
            CAST(ts.[uniquekey] AS BIGINT) AS [TRANSACTION_ID],
            CAST(i.itemid AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(l.[name] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(CONVERT(DATE, ts.[trandate], 103) AS DATE) AS [DATE],
            CAST(CAST(-ts.[quantity] AS DECIMAL(18,4)) / ISNULL(CAST(uom.conversionrate AS DECIMAL(18,4)),1) AS DECIMAL(18,4)) AS [SALE],
            CAST(c.entityid AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(ts.tranid AS NVARCHAR(255)) AS [REFERENCE_NO],
            CAST(0 AS BIT) AS [IS_EXCLUDED]
        FROM [cus].[TransactionSales] ts
		INNER JOIN [cus].[Item] i ON ts.item = i.id
		LEFT JOIN [cus].[Unitstypeuom] uom ON i.purchaseunit_id = uom.internalid
		INNER JOIN [cus].[Location] l ON ts.[location] = l.id
		INNER JOIN [cus].[Customer] c ON ts.entity = c.id

		UNION ALL

		SELECT 
			CAST(ts.[uniquekey] AS BIGINT) AS [TRANSACTION_ID],
			CAST(i.itemid AS NVARCHAR(255)) AS [ITEM_NO],
			CAST(l.[name] AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(CONVERT(DATE, ts.[trandate], 103) AS DATE) AS [DATE],
			CAST(CAST(-ts.[quantity] AS DECIMAL(18,4)) / ISNULL(CAST(uom.conversionrate AS DECIMAL(18,4)),1) AS DECIMAL(18,4)) AS [SALE],
			CAST(c.entityid AS NVARCHAR(255)) AS [CUSTOMER_NO],
			CAST(ts.tranid AS NVARCHAR(255)) AS [REFERENCE_NO],
			CAST(0 AS BIT) AS [IS_EXCLUDED]
		FROM [cus].[TransactionCashSales] ts
		INNER JOIN [cus].[Item] i ON ts.item = i.id
		LEFT JOIN [cus].[Unitstypeuom] uom ON i.purchaseunit_id = uom.internalid
		INNER JOIN [cus].[Location] l ON ts.[location] = l.id
		INNER JOIN [cus].[Customer] c ON ts.entity = c.id


