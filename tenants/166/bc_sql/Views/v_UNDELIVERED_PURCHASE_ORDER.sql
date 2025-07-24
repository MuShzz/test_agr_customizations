




-- ===============================================================================
-- Author:			Grétar Magnússon
-- Description:		Cus view 
--
-- 19.05.2025.GM	Removing variant codes
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_UNDELIVERED_PURCHASE_ORDER] AS

	SELECT
		CAST([Document No_] AS VARCHAR(128))													AS [PURCHASE_ORDER_NO],
		--CAST([No_] + CASE
		--				WHEN ISNULL([Variant Code], '') = '' THEN ''
		--				ELSE '-' + [Variant Code] END AS NVARCHAR(255))							AS [ITEM_NO],
		CAST(No_ AS NVARCHAR(255))																AS [ITEM_NO],
		CAST(IIF([Location Code] = 'KVÖRUH_IN', 'KVÖRUHÚS',[Location Code]) AS NVARCHAR(255))   AS [LOCATION_NO],
		CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4))									AS [QUANTITY],
		CAST(IIF([Expected Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(),
				[Expected Receipt Date]) AS DATE)												AS DELIVERY_DATE,
		[company]																				AS [Company]
	FROM
		bc_sql.PurchaseLine
	WHERE
		[Document Type] IN (1)
		AND [Drop Shipment] = 0
	GROUP BY
		[Document No_], [No_], [Location Code],
		CAST(IIF([Expected Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), [Expected Receipt Date]) AS DATE), [company]
	HAVING
		SUM([Outstanding Qty_ (Base)]) > 0

	UNION ALL --Stock on KVÖRUH_IN should map as undelivered on KVÖRUHÚS, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_KVÖRUH_IN' AS VARCHAR(128))																					AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																						AS [ITEM_NO],
		CAST('KVÖRUHÚS' AS NVARCHAR(255))																						AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																					AS [QUANTITY],
		CAST(MAX(IIF(pl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), ISNULL(pl.[Receipt Date], GETDATE()))) AS DATE)	AS DELIVERY_DATE,
		pl.company																												AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine pl ON pl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'KVÖRUH_IN'
		--AND sl.ITEM_NO = 'V011632'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		pl.company


