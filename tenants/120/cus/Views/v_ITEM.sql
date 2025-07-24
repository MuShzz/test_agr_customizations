
CREATE VIEW [cus].[v_ITEM] AS
	   SELECT
        CAST(OITM.[ItemCode] AS NVARCHAR(255))									AS [NO],
        CAST(OITM.[ItemName] AS NVARCHAR(255))									AS [NAME],
        CAST(NULL AS NVARCHAR(1000))											AS [DESCRIPTION],
        CAST(OITM.[CardCode] AS NVARCHAR(255))									AS [PRIMARY_VENDOR_NO],
        CAST(NULL AS INT)														AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) 													AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(OITM.[OrdrIntrvl] AS SMALLINT )									AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT ) 												AS [ORDER_COVERAGE_DAYS],
        CAST(OITM.[MinOrdrQty] AS DECIMAL(18,4))								AS [MIN_ORDER_QTY],
        CAST(OITM.[ItemCode] AS NVARCHAR(50))									AS [ORIGINAL_NO],
		CAST(IIF(OITM.[frozenFor]='Y' OR OITM.[QryGroup4] = 'Y',1,0) AS BIT)	AS [CLOSED],
        CAST(IIF(OITM.[frozenFor]='Y' OR OITM.[QryGroup4] = 'Y',1,0) AS BIT)	AS [CLOSED_FOR_ORDERING],
        CAST('' AS NVARCHAR(255)) 												AS [RESPONSIBLE],
        CAST(ISNULL(sp.[Price],0) AS DECIMAL(18,4))  							AS [SALE_PRICE],
        CAST(ISNULL(cp.[AvgPrice],0) AS DECIMAL(18,4))  						AS [COST_PRICE],
        CAST(ISNULL(pp.[Price],0) AS DECIMAL(18,4))  							AS [PURCHASE_PRICE],
        CAST(ISNULL(OITM.[OrdrMulti],1) AS DECIMAL(18,4))  						AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4))  											AS [QTY_PALLET],
        CAST(OITM.[BVolume] AS DECIMAL(18,6))  									AS [VOLUME],
        CAST(OITM.[SWeight1] AS DECIMAL(18,6))  								AS [WEIGHT],

		CAST(OITM.[MinLevel] AS DECIMAL(18,4))									AS [SAFETY_STOCK_UNITS],
		CAST(NULL AS DECIMAL(18,4))												AS [MIN_DISPLAY_STOCK],

        CAST(OITM.[MaxLevel] AS DECIMAL(18,4))  								AS [MAX_STOCK],
        CAST(OITM.[U_TRC_COLL_ITM_GROUP] AS NVARCHAR(255))  					AS [ITEM_GROUP_NO_LVL_1],
        CAST(OITM.[U_TRC_COLLECTION] AS NVARCHAR(255)) 							AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) 											AS [ITEM_GROUP_NO_LVL_3],
        CAST(NULL AS NVARCHAR(50)) 												AS [BASE_UNIT_OF_MEASURE],
        CAST(OITM.[BuyUnitMsr] AS NVARCHAR(50)) 								AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(OITM.[NumInBuy] AS DECIMAL(18,4)) 									AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS BIT) 															AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4)) 												AS [REORDER_POINT],
		CAST(1 AS BIT)															AS [INCLUDE_IN_AGR]
    FROM cus.OITM 
		--INNER JOIN cus.OSLP ON OITM.SlpCode = OSLP.SlpCode
		LEFT JOIN [cus].ITM1 sp ON OITM.Itemcode = sp.Itemcode AND sp.Pricelist = '20' -- '1' = Sale price
		-- LEFT JOIN [cus].ITM1 cp ON OITM.Itemcode = cp.Itemcode AND cp.Pricelist = '' -- '2' = Cost price -- change from 2 to 11 as requested from customer
		LEFT JOIN [cus].OITW cp ON OITM.Itemcode = cp.Itemcode AND cp.WhsCode = 'GEN'
		LEFT JOIN [cus].ITM1 pp ON OITM.Itemcode = pp.Itemcode AND pp.Pricelist = '1' -- '3' = Purchase price
	WHERE OITM.[ItemCode] IS NOT NULL 
		AND OITM.[ItemName] IS NOT NULL 
		AND OITM.[ItemName] <> 'DO NOT USE'

		/*
	  AND ((cp.WhsCode = 'GEN' AND OITM.U_TRC_COLL_ITM_GROUP NOT IN ('28','29'))
			OR
           (cp.WhsCode IN ('NB','NBL','NR','NRL','SPECIALS','WB', 'NSW') AND OITM.U_TRC_COLL_ITM_GROUP NOT IN ('1','2','3','4','9','10','11','12','25','28','29','33', '34'))
		  )
	  */

