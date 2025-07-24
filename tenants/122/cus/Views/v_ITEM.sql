
CREATE VIEW [cus].[v_ITEM] AS
	   SELECT
	CAST(it.ItemCode AS NVARCHAR(255)) AS [NO],
	CAST(ISNULL(it.ItemName,'') AS NVARCHAR(255)) AS [NAME],
        CAST('' AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(ISNULL(it.CardCode,'vendor_missing') AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST((ISNULL(it.U_ProductionTime,0) + ISNULL(it.U_DaysAtSea,0))/5*2 AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(it.OrdrIntrvl AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS],
        CAST(it.MinOrdrQty  AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
        CAST(vex.Substitute AS NVARCHAR(50)) AS [ORIGINAL_NO],
		CAST(IIF(it.PrchseItem = 'Y' AND it.InvntItem = 'Y' AND it.frozenFor = 'N', 0, 1) AS BIT) AS CLOSED,
        CAST(0 AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(ISNULL(re.SlpName,'') AS NVARCHAR(255)) AS [RESPONSIBLE],
        CAST(COALESCE(sp.Price,0.0000) AS DECIMAL(18,4)) AS [SALE_PRICE],
        CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE],
        CAST(pp.Price AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(it.OrdrMulti AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET],
        CAST(it.BVolume AS DECIMAL(18,6)) AS [VOLUME],
        CAST(it.BWeight1 AS DECIMAL(18,6)) AS [WEIGHT],

		CAST(it.MinLevel AS DECIMAL(18,4))	AS [SAFETY_STOCK_UNITS],
		CAST(NULL AS DECIMAL(18,4))			AS [MIN_DISPLAY_STOCK],

        CAST(it.MaxLevel AS DECIMAL(18,4)) AS [MAX_STOCK],
        CAST(it.ItmsGrpCod AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST('' AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(it.BuyUnitMsr AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(it.NumInBuy AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(IIF(it.QryGroup10='Y', 1,0) AS BIT) AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
		CAST(0 AS BIT) AS [INCLUDE_IN_AGR]
    FROM
        [cus].OITM it
		LEFT JOIN [cus].ITM1 sp ON it.Itemcode = sp.Itemcode AND sp.Pricelist = '2' -- '1' = Sale price -- BF change to 2 for tis client
		--LEFT JOIN [cus].ITM1 cp ON it.Itemcode = cp.Itemcode AND cp.Pricelist = '2' -- '2' = Cost price -- BF Cost price is per warehouse not mapped here
		LEFT JOIN [cus].ITM1 pp ON it.Itemcode = pp.Itemcode AND pp.Pricelist = '1' -- '3' = Purchase price -- BF change to 1 for tis client
		LEFT JOIN [cus].OCRD ve ON ve.CardCode = it.CardCode
		LEFT JOIN [cus].OSLP re ON re.SlpCode = ve.SlpCode
		LEFT JOIN [cus].OSCN vex ON vex.ItemCode = it.ItemCode AND vex.CardCode=it.CardCode

