

CREATE VIEW [bc_sql_cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
    
	--If location is VÖRUHÚS_IN then mapped onto VÖRUHÚS and G locations map to corresponding locations.
	SELECT
		CAST([Document No_] AS VARCHAR(128))																		AS [PURCHASE_ORDER_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
		CASE WHEN
				[Location Code] = 'VÖRUHÚS_IN' THEN 'VÖRUHÚS'
			 WHEN
				[Location Code] = 'G-FITJAR' THEN 'FITJAR'
			 WHEN
				[Location Code] = 'G-BÍLDSH' THEN 'BÍLDSHÖFÐI'
             WHEN
				[Location Code] = 'G-GRANDI' THEN 'GRANDI'
			 WHEN
				[Location Code] = 'G-SELFOSS' THEN 'SELFOSS'
			 WHEN
				[Location Code] = 'G-SKEIFU' THEN 'SKEIFAN'
			 WHEN
				[Location Code] = 'G-SMÁRA' THEN 'SMÁRATORG'
			 WHEN
				[Location Code] = 'G-AKUREYRI' THEN 'AKUREYRI'
			 ELSE
				[Location Code] END																					AS [LOCATION_NO],
		CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4))														AS [QUANTITY],
		CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)		AS DELIVERY_DATE,
		[company]																									AS [Company]
	FROM
		[bc_sql].PurchaseLine
	WHERE
		[Document Type] IN (1)
		AND [Drop Shipment] = 0
	GROUP BY
		[Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE), [company]
	HAVING
		SUM([Outstanding Qty_ (Base)]) > 0

	UNION ALL --Stock on VÖRUHÚS_IN should map as undelivered on VÖRUHÚS, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_VÖRUHÚS_IN' AS VARCHAR(128))																				AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																						AS [ITEM_NO],
		CAST('VÖRUHÚS' AS NVARCHAR(255))																						AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																					AS [QUANTITY],
		CAST(MAX(IIF(pl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), ISNULL(pl.[Receipt Date], GETDATE()))) AS DATE)	AS DELIVERY_DATE,
		pl.company																												AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine pl ON pl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'VÖRUHÚS_IN'
		--AND sl.ITEM_NO = 'V011632'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		pl.company

	UNION ALL --Stock on G-FITJAR should map as undelivered on FITJAR, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_G_FITJAR' AS VARCHAR(128))																					AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																						AS [ITEM_NO],
		CAST('FITJAR' AS NVARCHAR(255))																							AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																					AS [QUANTITY],
		CAST(MAX(IIF(pl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), ISNULL(pl.[Receipt Date], GETDATE()))) AS DATE)	AS DELIVERY_DATE,
		pl.company																												AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine pl ON pl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'G-FITJAR'
		--AND sl.ITEM_NO = 'V011632'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		pl.company

	UNION ALL --Stock on G-BÍLDSH should map as undelivered on BÍLDSHÖFÐI, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_G_BÍLDSHÖFÐI' AS VARCHAR(128))																				AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																						AS [ITEM_NO],
		CAST('BÍLDSHÖFÐI' AS NVARCHAR(255))																						AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																					AS [QUANTITY],
		CAST(MAX(IIF(pl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), ISNULL(pl.[Receipt Date], GETDATE()))) AS DATE)	AS DELIVERY_DATE,
		pl.company																												AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine pl ON pl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'G-BÍLDSH'
		--AND sl.ITEM_NO = 'V011632'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		pl.company

	UNION ALL --Stock on G-GRANDI should map as undelivered on GRANDI, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_G_GRANDI' AS VARCHAR(128))																					AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																						AS [ITEM_NO],
		CAST('GRANDI' AS NVARCHAR(255))																							AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																					AS [QUANTITY],
		CAST(MAX(IIF(pl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), ISNULL(pl.[Receipt Date], GETDATE()))) AS DATE)	AS DELIVERY_DATE,
		pl.company																												AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine pl ON pl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'G-GRANDI'
		--AND sl.ITEM_NO = 'V011632'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		pl.company

	UNION ALL --Stock on G-SELFOSS should map as undelivered on SELFOSS, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_G_SELFOSS' AS VARCHAR(128))																					AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																						AS [ITEM_NO],
		CAST('SELFOSS' AS NVARCHAR(255))																						AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																					AS [QUANTITY],
		CAST(MAX(IIF(pl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), ISNULL(pl.[Receipt Date], GETDATE()))) AS DATE)	AS DELIVERY_DATE,
		pl.company																												AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine pl ON pl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'G-SELFOSS'
		--AND sl.ITEM_NO = 'V011632'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		pl.company

	UNION ALL --Stock on G-SKEIFU should map as undelivered on SKEIFAN, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_G_SKEIFAN' AS VARCHAR(128))																					AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																						AS [ITEM_NO],
		CAST('SKEIFAN' AS NVARCHAR(255))																						AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																					AS [QUANTITY],
		CAST(MAX(IIF(pl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), ISNULL(pl.[Receipt Date], GETDATE()))) AS DATE)	AS DELIVERY_DATE,
		pl.company																												AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine pl ON pl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'G-SKEIFU'
		--AND sl.ITEM_NO = 'V011632'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		pl.company

	UNION ALL --Stock on G-SMÁRA should map as undelivered on SMÁRATORG, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_G_SMÁRATORG' AS VARCHAR(128))																				AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																						AS [ITEM_NO],
		CAST('SMÁRATORG' AS NVARCHAR(255))																						AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																					AS [QUANTITY],
		CAST(MAX(IIF(pl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), ISNULL(pl.[Receipt Date], GETDATE()))) AS DATE)	AS DELIVERY_DATE,
		pl.company																												AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine pl ON pl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'G-SMÁRA'
		--AND sl.ITEM_NO = 'V011632'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		pl.company

	UNION ALL --Stock on G-AKUREYRI should map as undelivered on AKUREYRI, max of receipt date is taken if there are more than 1 records in transferline table.
    
	SELECT
		CAST('STOCK_G_AKUREYRI' AS VARCHAR(128))																				AS [PURCHASE_ORDER_NO],
		CAST(sl.ITEM_NO AS NVARCHAR(255))																						AS [ITEM_NO],
		CAST('AKUREYRI' AS NVARCHAR(255))																						AS [LOCATION_NO],
		CAST(sl.STOCK_UNITS AS DECIMAL(18, 4))																					AS [QUANTITY],
		CAST(MAX(IIF(pl.[Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), ISNULL(pl.[Receipt Date], GETDATE()))) AS DATE)	AS DELIVERY_DATE,
		pl.company																												AS [Company]
	FROM
		bc_sql.v_STOCK_LEVEL sl
		LEFT JOIN bc_sql.TransferLine pl ON pl.[Item No_] = sl.ITEM_NO
	WHERE
		sl.LOCATION_NO = 'G-AKUREYRI'
		--AND sl.ITEM_NO = 'V011632'
	GROUP BY
		sl.ITEM_NO,
		sl.LOCATION_NO,
		sl.STOCK_UNITS,
		pl.company


