


-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM] AS
	   SELECT
        CAST(it.ItemCode AS NVARCHAR(255)) AS [NO],
        CAST(ISNULL(it.ItemName,'') AS NVARCHAR(255)) AS [NAME],
        CAST('' AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(ISNULL(it.CardCode,'vendor_missing') AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],

        ((it.LeadTime + ISNULL(it.ToleranDay,0)) % 5) +
		CASE ((@@DATEFIRST + DATEPART(WEEKDAY, GETDATE()) + ((it.LeadTime + ISNULL(it.ToleranDay,0)) % 5)) % 7)
		WHEN 0 THEN 2
		WHEN 1 THEN 1
		ELSE 0 END  + ((it.LeadTime + ISNULL(it.ToleranDay,0))/5) * 7 AS [PURCHASE_LEAD_TIME_DAYS],

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

        CASE ISNUMERIC(it.U_palletQty) 
			WHEN 1 THEN CAST(CAST(it.U_palletQty AS MONEY) AS INT)
			ELSE CAST(NULL AS INT)
		END AS [QTY_PALLET],

        CAST(it.SVolume*0 AS DECIMAL(18,6)) AS [VOLUME],

        CASE WHEN ISNUMERIC(u_plasticweightpereach) = 1 THEN
			CAST(u_plasticweightpereach AS DECIMAL(18,4))
			ELSE CAST(NULL AS DECIMAL(18,4)) 
		END AS [WEIGHT],

        CAST(it.MinLevel AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],


        CAST(it.MaxLevel AS DECIMAL(18,4)) AS [MAX_STOCK],
        CAST(it.ItmsGrpCod AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(it.U_SanaCategoryLevel2 AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST('' AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(it.BuyUnitMsr  AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(it.NumInBuy AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(IIF(it.QryGroup16 = 'Y' , 0, 1) AS BIT) AS [SPECIAL_ORDER],
        CAST(COALESCE(it.ReorderPnt,0) AS DECIMAL(18,4)) AS [REORDER_POINT],
		CAST(0 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(IIF(it.PrchseItem = 'Y' AND it.InvntItem = 'Y' AND it.frozenFor = 'N', 0, 1) AS BIT) AS [CLOSED]
    FROM
        [cus].OITM it
		LEFT JOIN [cus].ITM1 sp ON it.Itemcode = sp.Itemcode AND sp.Pricelist = '1' -- '1' = Sale price
		LEFT JOIN [cus].ITM1 cp ON it.Itemcode = cp.Itemcode AND cp.Pricelist = '11' -- '2' = Cost price -- change from 2 to 11 as requested from customer
		LEFT JOIN [cus].ITM1 pp ON it.Itemcode = pp.Itemcode AND cp.Pricelist = '3' -- '3' = Purchase price
		LEFT JOIN [cus].OCRD ve ON ve.CardCode = it.CardCode
		LEFT JOIN [cus].OSLP re ON re.SlpCode = ve.SlpCode
	WHERE it.PrchseItem = 'Y' AND it.InvntItem = 'Y' AND (it.frozenFor = 'N' OR (it.frozenFor = 'Y' AND QryGroup10 = 'Y')) --only take these items as requested from customer




