CREATE VIEW [bc_sql_cus].[v_UNDELIVERED_PURCHASE_ORDER] AS

	SELECT
		CAST([Document No_] AS VARCHAR(128))																		AS [PURCHASE_ORDER_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
		CAST(IIF([Location Code] = 'G-SKEMMAN', 'SKEMMAN', [Location Code]) AS NVARCHAR(255))						AS [LOCATION_NO],
		CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4))														AS [QUANTITY],
		CAST(IIF([Expected Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), [Expected Receipt Date]) AS DATE)	AS DELIVERY_DATE,
		[company]																									AS [Company]
	FROM
		[bc_sql].PurchaseLine
	WHERE
		[Document Type] IN (1)
		AND [Drop Shipment] = 0
	    --AND [Expected Receipt Date] is not null
		--AND [Location Code] NOT IN ('G-SKEMMAN')
		--AND No_ = 'G004021'
	GROUP BY
		[Document No_],
        [No_],
        [Variant Code],
        [Location Code],
        CAST(IIF([Expected Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), [Expected Receipt Date]) AS DATE),
        [Company]
	HAVING
		SUM([Outstanding Qty_ (Base)]) > 0

	UNION ALL --Stock on G-SKEMMAN should map as undelivered on SKEMMAN, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_G-SKEMMAN' AS VARCHAR(128))																	AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																		AS [ITEM_NO],
		CAST('SKEMMAN' AS NVARCHAR(255))																		AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																	AS [QUANTITY],
		CAST(MAX(IIF(tl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), tl.[Receipt Date])) AS DATE)		AS DELIVERY_DATE,
		tl.company																								AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine tl ON tl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'G-SKEMMAN'
        AND [Receipt Date] is not null -- added by Mendes on 2025-07-18 so the DJ would run
		--AND sl.ITEM_NO = 'G004021'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		tl.company
