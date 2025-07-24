
CREATE VIEW [bc_sql_cus].[v_UNDELIVERED_PURCHASE_ORDER_BACKUP_10072025] AS
    
	--If location is VÖRUHÚS_IN then mapped onto VÖRUHÚS
	SELECT
		CAST([Document No_] AS VARCHAR(128))																		AS [PURCHASE_ORDER_NO],
		--CAST([No_] + CASE
		--				WHEN ISNULL([Variant Code], '') = '' THEN
		--					''
		--				ELSE
		--					'-' + [Variant Code]
		--			END AS NVARCHAR(255))																			AS [ITEM_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
		CAST(IIF([Location Code] = 'VÖRUHÚS_IN', 'VÖRUHÚS', [Location Code]) AS NVARCHAR(255))						AS [LOCATION_NO],
		CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4))														AS [QUANTITY],
		CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)		AS DELIVERY_DATE
	FROM
		[bc_sql].PurchaseLine
	WHERE
		[Document Type] IN (1)
		AND [Drop Shipment] = 0
		AND [Location Code] NOT LIKE 'G-%'
	GROUP BY
		[Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)
	HAVING
		SUM([Outstanding Qty_ (Base)]) > 0

	UNION ALL --Get G locations undelivered on the matching stores (G-FITJAR => FITJAR for example)

	SELECT
        CAST([Document No_] AS VARCHAR(128))																		AS [PURCHASE_ORDER_NO],
        --CAST([No_] + CASE
		--				WHEN ISNULL([Variant Code], '') = '' THEN
		--					''
		--				ELSE
		--					'-' + [Variant Code]
		--			END AS NVARCHAR(255))																			AS [ITEM_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
        CAST('FITJAR' AS NVARCHAR(255))																				AS [LOCATION_NO],
        CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4))														AS [QUANTITY],
        CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)		AS DELIVERY_DATE
    FROM
        [bc_sql].PurchaseLine
    WHERE
        [Document Type] IN (1)
        AND [Drop Shipment] = 0
		AND [Location Code] = 'G-FITJAR'
		--AND No_ = 'P008059'
    GROUP BY
        [Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)
    HAVING SUM([Outstanding Qty_ (Base)]) > 0

	UNION ALL --Get G locations undelivered on the matching stores

	SELECT
		CAST([Document No_] AS VARCHAR(128))																		AS [PURCHASE_ORDER_NO],
		--CAST([No_] + CASE
		--				WHEN ISNULL([Variant Code], '') = '' THEN
		--					''
		--				ELSE
		--					'-' + [Variant Code]
		--			END AS NVARCHAR(255))																			AS [ITEM_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
		CAST('BÍLDSHÖFÐI' AS NVARCHAR(255))																			AS [LOCATION_NO],
		CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4))														AS [QUANTITY],
		CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)		AS DELIVERY_DATE
	FROM
		[bc_sql].PurchaseLine
	WHERE
		[Document Type] IN (1)
		AND [Drop Shipment] = 0
		AND [Location Code] = 'G-BÍLDSH'
		--AND No_ = 'P008059'
	GROUP BY
		[Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)
	HAVING SUM([Outstanding Qty_ (Base)]) > 0

	UNION ALL --Get G locations undelivered on the matching stores

	SELECT
		CAST([Document No_] AS VARCHAR(128))																		AS [PURCHASE_ORDER_NO],
		--CAST([No_] + CASE
		--				WHEN ISNULL([Variant Code], '') = '' THEN
		--					''
		--				ELSE
		--					'-' + [Variant Code]
		--			END AS NVARCHAR(255))																			AS [ITEM_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
		CAST('GRANDI' AS NVARCHAR(255))																				AS [LOCATION_NO],
		CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4))														AS [QUANTITY],
		CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)		AS DELIVERY_DATE
	FROM
		[bc_sql].PurchaseLine
	WHERE
		[Document Type] IN (1)
		AND [Drop Shipment] = 0
		AND [Location Code] = 'G-GRANDI'
		--AND No_ = 'P008059'
	GROUP BY
		[Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)
	HAVING SUM([Outstanding Qty_ (Base)]) > 0

	UNION ALL --Get G locations undelivered on the matching stores

		SELECT
			CAST([Document No_] AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
			--CAST([No_] + CASE
		--				WHEN ISNULL([Variant Code], '') = '' THEN
		--					''
		--				ELSE
		--					'-' + [Variant Code]
		--			END AS NVARCHAR(255))																			AS [ITEM_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
			CAST('SELFOSS' AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4)) AS [QUANTITY],
			CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE) AS DELIVERY_DATE
		FROM
			[bc_sql].PurchaseLine
		WHERE
			[Document Type] IN (1)
			AND [Drop Shipment] = 0
			AND [Location Code] = 'G-SELFOSS'
			--AND No_ = 'P008059'
		GROUP BY
			[Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)
		HAVING SUM([Outstanding Qty_ (Base)]) > 0

		UNION ALL --Get G locations undelivered on the matching stores

		SELECT
			CAST([Document No_] AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
			--CAST([No_] + CASE
		--				WHEN ISNULL([Variant Code], '') = '' THEN
		--					''
		--				ELSE
		--					'-' + [Variant Code]
		--			END AS NVARCHAR(255))																			AS [ITEM_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
			CAST('SKEIFAN' AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4)) AS [QUANTITY],
			CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE) AS DELIVERY_DATE
		FROM
			[bc_sql].PurchaseLine
		WHERE
			[Document Type] IN (1)
			AND [Drop Shipment] = 0
			AND [Location Code] = 'G-SKEIFU'
			--AND No_ = 'P008059'
		GROUP BY
			[Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)
		HAVING SUM([Outstanding Qty_ (Base)]) > 0

		UNION ALL --Get G locations undelivered on the matching stores

		SELECT
			CAST([Document No_] AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
			--CAST([No_] + CASE
		--				WHEN ISNULL([Variant Code], '') = '' THEN
		--					''
		--				ELSE
		--					'-' + [Variant Code]
		--			END AS NVARCHAR(255))																			AS [ITEM_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
			CAST('SMÁRATORG' AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4)) AS [QUANTITY],
			CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE) AS DELIVERY_DATE
		FROM
			[bc_sql].PurchaseLine
		WHERE
			[Document Type] IN (1)
			AND [Drop Shipment] = 0
			AND [Location Code] = 'G-SMÁRA'
			--AND No_ = 'P008059'
		GROUP BY
			[Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)
		HAVING SUM([Outstanding Qty_ (Base)]) > 0

		UNION ALL --Get G locations undelivered on the matching stores

		SELECT
			CAST([Document No_] AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
			--CAST([No_] + CASE
		--				WHEN ISNULL([Variant Code], '') = '' THEN
		--					''
		--				ELSE
		--					'-' + [Variant Code]
		--			END AS NVARCHAR(255))																			AS [ITEM_NO],
		CAST(No_ AS NVARCHAR(255))																					AS [ITEM_NO],
			CAST('AKUREYRI' AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4)) AS [QUANTITY],
			CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE) AS DELIVERY_DATE
		FROM
			[bc_sql].PurchaseLine
		WHERE
			[Document Type] IN (1)
			AND [Drop Shipment] = 0
			AND [Location Code] = 'G-AKUREYRI'
			--AND No_ = 'P008059'
		GROUP BY
			[Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)
		HAVING SUM([Outstanding Qty_ (Base)]) > 0


