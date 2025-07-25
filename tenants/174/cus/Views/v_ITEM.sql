
CREATE VIEW [cus].[v_ITEM]
AS

	-- cte used for the purchase unit of measure logic instead of getting the purchase order route view
	-- basically the por view without columns

	WITH purchase_unit_of_measure_cte AS (
		SELECT DISTINCT
			CAST(it.ITEMID AS NVARCHAR(255))						AS [ITEM_NO],
			CAST('ADF' AS NVARCHAR(255))							AS [LOCATION_NO],
			CAST(CEILING((CASE iips.MultipleQty 
							WHEN 0 THEN 1 
						ELSE iips.MultipleQty 
						END)/
						(CASE uc.Factor 
							WHEN 0 THEN 1 
						ELSE uc.Factor 
						END)) AS DECIMAL(18, 4))					AS [ORDER_MULTIPLE], 
			CAST(it.AGRStandardPalletQuantity  AS DECIMAL(18, 4))   AS [QTY_PALLET]
		FROM cus.INVENTTABLE it
			INNER JOIN cus.DataAreas da ON da.company_id=it.DATAAREAID
			INNER JOIN cus.UnitConvert uc ON uc.ITEMID=it.ITEMID 
			INNER JOIN cus.INVENTITEMPURCHSETUP iips ON iips.ITEMID=it.ITEMID AND iips.DATAAREAID=it.DATAAREAID
			INNER JOIN cus.VENDTABLE v ON v.ACCOUNTNUM = it.PRIMARYVENDORID AND v.DATAAREAID=da.company_id
			INNER JOIN cus.INVENTTABLEMODULE itm ON itm.ITEMID=it.ITEMID AND itm.DATAAREAID=da.company_id AND itm.UNITID=uc.FROMUNIT
			INNER JOIN cus.INVENTDIM AS dim ON dim.INVENTDIMID = iips.INVENTDIMIDDEFAULT AND dim.DATAAREAID = iips.DATAAREAID
		WHERE uc.ToUnit='ks'
			AND itm.MODULETYPE=0
			AND (CASE 
					WHEN it.CESPECIALPURCHASE = 1 THEN 1
				ELSE ISNULL(it.AGRBlocked,0) 
				END) = 0
		GROUP BY it.ITEMID, it.PRIMARYVENDORID, iips.LOWESTQTY, iips.MULTIPLEQTY, uc.FACTOR, it.CEAGRLEADTIME, 
				v.AGRDELIVERYTIME, it.AGRStandardPalletQuantity, it.AGRQtyPerLayer,dim.INVENTLOCATIONID,iips.LEADTIME,
				itm.PRICE,iips.DATAAREAID 
	),

	resolved_multiple AS (
		SELECT it.ITEMID  AS [NO],
			CASE 
				WHEN pumcte.ORDER_MULTIPLE IS NULL THEN 
					CASE 
						WHEN ISNULL(CAST(iips.MULTIPLEQTY AS DECIMAL(18,4)),0) < 1 THEN 1 
						ELSE ISNULL(CAST(iips.MULTIPLEQTY AS DECIMAL(18,4)),0) 
					END
				ELSE pumcte.ORDER_MULTIPLE
			END AS ORDER_MULTIPLE
		FROM cus.INVENTTABLE  it 
		LEFT JOIN cus.INVENTTABLEMODULE itm ON it.ITEMID = itm.ITEMID AND itm.DATAAREAID = it.DATAAREAID  AND itm.MODULETYPE = 2 -- Moduletype = 'Sales'
		LEFT JOIN cus.INVENTTABLEMODULE itm2 ON it.ITEMID = itm2.ITEMID AND itm2.DATAAREAID = it.DATAAREAID AND itm2.MODULETYPE = 1 -- Moduletype = 'Purchases'
		INNER JOIN cus.InventItemPurchSetup AS iips ON iips.ItemId = itm.ItemId AND iips.DataAreaId = itm.DataAreaId
		INNER JOIN cus.VENDTABLE v ON v.ACCOUNTNUM=it.PRIMARYVENDORID 
		LEFT JOIN purchase_unit_of_measure_cte pumcte ON it.ITEMID = pumcte.ITEM_NO
	)

	SELECT DISTINCT
		CAST(it.ITEMID AS NVARCHAR(255))							AS [NO],
		CAST(it.ItemName AS NVARCHAR(255))							AS [NAME],
		CAST('' AS NVARCHAR(1000))									AS [DESCRIPTION],
		CAST(CASE it.PrimaryVendorId 
				WHEN '' THEN 'AGR-ERROR' 
			ELSE it.PrimaryVendorId END AS NVARCHAR(255))			AS [PRIMARY_VENDOR_NO],
		CAST(NULL AS SMALLINT)										AS [PURCHASE_LEAD_TIME_DAYS],
		CAST(NULL AS SMALLINT)										AS [TRANSFER_LEAD_TIME_DAYS],
		CAST(CASE 
				WHEN it.AGROrderFrequency > 0 THEN it.AGROrderFrequency 
				ELSE v.AGRORDERFREQUENCY END AS SMALLINT )			AS [ORDER_FREQUENCY_DAYS],
		CAST(0 AS SMALLINT )										AS [ORDER_COVERAGE_DAYS],
		CAST(NULL AS DECIMAL(18,4))									AS [MIN_ORDER_QTY],
		CAST(ISNULL(cve.EXTERNALITEMID, '') AS NVARCHAR(50)) 		AS [ORIGINAL_NO],
		CAST(CASE WHEN it.CESPECIALPURCHASE = 1 THEN 1
			WHEN iips.STOPPED  =1 THEN 1 
			ELSE ISNULL(it.AGRBlocked,0) END AS BIT)				AS [CLOSED],
		CAST(NULL AS BIT)											AS [CLOSED_FOR_ORDERING],
		CAST(CASE 
				WHEN it.AGRResponsible <>'' THEN it.AGRResponsible 
			ELSE v.AGRResponsible END AS NVARCHAR(255))				AS [RESPONSIBLE],
		CAST(ISNULL(uc.Factor * itm.Price / 
					CASE itm.PriceUnit 
						WHEN 0 THEN 1 
					ELSE itm.PriceUnit END,0) AS DECIMAL(18,4))     AS [SALE_PRICE],
		CAST(itm.PRICE AS DECIMAL(18,4)) / 
			(CASE 
				WHEN CAST(itm.PRICEUNIT AS DECIMAL(18,4)) = 0 THEN 1 
			ELSE CAST(itm.PRICEUNIT AS DECIMAL(18,4)) 
			END)													AS [COST_PRICE],
		CAST(itm2.PRICE AS DECIMAL(18,4)) / 
				(CASE 
					WHEN CAST(itm2.PRICEUNIT AS DECIMAL(18,4)) = 0 THEN 1 
				ELSE CAST(itm2.PRICEUNIT AS DECIMAL(18,4)) 
				END)												AS [PURCHASE_PRICE],
		CAST(CASE 
				WHEN ISNULL(CAST(iips.MULTIPLEQTY AS DECIMAL(18,4)),0) < 1 THEN 1 
			ELSE ISNULL(CAST(iips.MULTIPLEQTY AS DECIMAL(18,4)),0) 
			END AS DECIMAL(18,4))									AS [ORDER_MULTIPLE],
		CAST(it.AGRSTANDARDPALLETQUANTITY AS DECIMAL(18,4))			AS [QTY_PALLET], --10.07.2025.DFS/RDG changed by requst of team at Adfong
		CAST(it.UnitVolume AS DECIMAL(18,6))						AS [VOLUME],
		CAST(it.NetWeight AS DECIMAL(18,6))							AS [WEIGHT],
		CAST(0 AS DECIMAL(18,4))									AS [SAFETY_STOCK_UNITS],
		CAST(NULL AS DECIMAL(18,4))									AS [MIN_DISPLAY_STOCK],
		CAST(NULL AS DECIMAL(18,4))									AS [MAX_STOCK],
		CAST(cig.MAJORGROUPID +'-'+ cig.NAME AS NVARCHAR(255))		AS [ITEM_GROUP_NO_LVL_1],
		CAST(it.ITEMGROUPID AS NVARCHAR(255))						AS [ITEM_GROUP_NO_LVL_2],
		CAST(NULL AS NVARCHAR(255))									AS [ITEM_GROUP_NO_LVL_3],
		CAST(NULL AS NVARCHAR(50))									AS [BASE_UNIT_OF_MEASURE],
		CAST(CASE WHEN IIF(pumcte.ORDER_MULTIPLE IS NULL, rm.ORDER_MULTIPLE, pumcte.ORDER_MULTIPLE) = 1 THEN 'Kassar'
				  WHEN IIF(pumcte.ORDER_MULTIPLE IS NULL, rm.ORDER_MULTIPLE, pumcte.ORDER_MULTIPLE) = it.AGRQTYPERLAYER THEN 'Lag' 
				  WHEN IIF(pumcte.ORDER_MULTIPLE IS NULL, rm.ORDER_MULTIPLE, pumcte.ORDER_MULTIPLE) = pumcte.QTY_PALLET THEN 'Bretti'
				  ELSE 'Annað' END AS NVARCHAR(50))								AS [PURCHASE_UNIT_OF_MEASURE],
		CAST(NULL AS DECIMAL(18,4))									AS [QTY_PER_PURCHASE_UNIT],
		CAST(ISNULL(NULL,0) AS DECIMAL(18,4))						AS [REORDER_POINT],
		CAST(NULL AS BIT)											AS [SPECIAL_ORDER],
		CAST(1 AS BIT)												AS [INCLUDE_IN_AGR]
	FROM cus.INVENTTABLE  it 
		INNER JOIN cus.DataAreas da ON da.company_id = it.DATAAREAID
		LEFT JOIN cus.INVENTTABLEMODULE itm ON it.ITEMID = itm.ITEMID AND itm.DATAAREAID = it.DATAAREAID  AND itm.MODULETYPE = 2 -- Moduletype = 'Sales'
		LEFT JOIN cus.INVENTTABLEMODULE itm2 ON it.ITEMID = itm2.ITEMID AND itm2.DATAAREAID = it.DATAAREAID AND itm2.MODULETYPE = 1 -- Moduletype = 'Purchases'
		INNER JOIN cus.InventItemPurchSetup AS iips ON iips.ItemId = itm.ItemId AND iips.DataAreaId = itm.DataAreaId
		INNER JOIN cus.CEBPLINVENTITEMMAJORGROUP cig ON it.CEBplItemMajorGroupId = cig.MAJORGROUPID AND it.ITEMGROUPID = cig.ITEMGROUPID AND it.DATAAREAID = cig.DATAAREAID
		INNER JOIN cus.VENDTABLE v ON v.ACCOUNTNUM=it.PRIMARYVENDORID 
		INNER JOIN cus.UNITCONVERT uc ON uc.ITEMID=it.ITEMID AND uc.DATAAREAID=da.company_id AND uc.FROMUNIT=itm.UNITID
		LEFT OUTER JOIN(
				SELECT DISTINCT [DATAAREAID],[ITEMID],MIN([INVENTDIMID]) AS [INVENTDIMID],MIN([EXTERNALITEMID]) AS [EXTERNALITEMID],[ModuleType] ,[CustVendRelation]
				FROM cus.[CUSTVENDEXTERNALITEM]
				WHERE MODULETYPE=3
				GROUP BY [DATAAREAID], [ITEMID], [ModuleType], [CustVendRelation]
					) cve ON it.DataAreaId  = cve.DataAreaId AND it.ItemId = cve.ItemId AND cve.CustVendRelation = it.PrimaryVendorId 
		LEFT JOIN purchase_unit_of_measure_cte pumcte ON it.ITEMID = pumcte.ITEM_NO
		LEFT JOIN resolved_multiple rm ON it.ITEMID = rm.NO
	WHERE itm.ModuleType =2  
		AND uc.TOUNIT='ks'
		AND it.REQGROUPID != 'Transit' -- 24.06.2025.DFS Excluding REQGROUPID = 'Transit' logic moved from cus override columns


