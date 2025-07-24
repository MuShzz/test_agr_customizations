


-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_STOCK_HISTORY] AS
       SELECT
            CAST(t.[uniquekey] AS BIGINT) AS [TRANSACTION_ID],
            CAST(i.itemid AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(l.[name] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(CONVERT(DATE, t.[trandate], 103) AS DATE) AS [DATE],
            CAST(CAST(t.[quantity] AS DECIMAL(18,4)) / ISNULL(CAST(uom.conversionrate AS DECIMAL(18,4)),1) AS DECIMAL(18,4)) AS [STOCK_MOVE],
            CAST(NULL AS DECIMAL(18, 4)) AS [STOCK_LEVEL]
         FROM [cus].[Transaction] t
			INNER JOIN [cus].[Item] i ON t.item = i.id
			INNER JOIN [cus].[Location] l ON t.[location] = l.id
			LEFT JOIN [cus].[Unitstypeuom] uom ON i.purchaseunit_id = uom.internalid

