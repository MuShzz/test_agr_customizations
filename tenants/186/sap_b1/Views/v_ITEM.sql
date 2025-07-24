
CREATE VIEW [sap_b1_cus].[v_ITEM] AS
	   SELECT
        CAST(it.ItemCode AS NVARCHAR(255)) AS [NO],
        CAST(ISNULL(it.ItemName,'') AS NVARCHAR(255)) AS [NAME],
        CAST('' AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(ISNULL(it.CardCode,'vendor_missing') AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
		CAST(it.LeadTime AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(it.OrdrIntrvl AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS],
        CAST(it.MinOrdrQty AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
        CAST(it.ItemCode AS NVARCHAR(50)) AS [ORIGINAL_NO],
        CAST(0 AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(ISNULL(re.SlpName,'') AS NVARCHAR(255)) AS [RESPONSIBLE],
        CAST(COALESCE(sp.Price,0.0000) AS DECIMAL(18,4)) AS [SALE_PRICE],
        CAST(cp.Price AS DECIMAL(18,4)) AS [COST_PRICE],
        CAST(pp.Price AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(it.OrdrMulti AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(NULL AS INT) AS [QTY_PALLET],
        CAST(it.SVolume AS DECIMAL(18,6)) AS [VOLUME],
        CAST(it.SWeight1 AS DECIMAL(18,6)) AS [WEIGHT],
        CAST(it.MinLevel AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
	    CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
        CAST(it.MaxLevel AS DECIMAL(18,4)) AS [MAX_STOCK],
        CAST(it.ItmsGrpCod AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST('' AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(it.BuyUnitMsr  AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(it.NumInBuy AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS BIT) AS [SPECIAL_ORDER],
        CAST(COALESCE(it.ReorderPnt,0) AS DECIMAL(18,4)) AS [REORDER_POINT],
		CAST(0 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(IIF((it.[PrchseItem] ='Y' OR  it.[SellItem] ='Y') AND  it.[InvntItem] ='Y' AND  it.[frozenFor] = 'N', 0, 1) AS BIT) AS [CLOSED]
    FROM
        [sap_b1].OITM it
		LEFT JOIN [sap_b1].ITM1 sp ON it.ItemCode = sp.ItemCode AND sp.PriceList = '1' -- '1' = Sale price
		LEFT JOIN [sap_b1].ITM1 cp ON it.ItemCode = cp.ItemCode AND cp.PriceList = '59' -- '2' = Cost price 
		--LEFT JOIN [sap_b1].ITM1 cp ON it.ItemCode = cp.ItemCode AND cp.PriceList = '2' -- '2' = Cost price 
		LEFT JOIN [sap_b1].ITM1 pp ON it.ItemCode = pp.ItemCode AND pp.PriceList = '3' -- '3' = Purchase price
		LEFT JOIN [sap_b1].OCRD ve ON ve.CardCode = it.CardCode
		LEFT JOIN [sap_b1].OSLP re ON re.SlpCode = ve.SlpCode

