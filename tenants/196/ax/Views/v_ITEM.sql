

CREATE VIEW [ax_cus].[v_ITEM] AS

WITH cte AS (
	SELECT 
		DISTINCT(
			it.[ITEMID] + 
			CASE 
				WHEN ind.INVENTSIZEID<>'' AND ind.INVENTSIZEID IS NOT NULL THEN '_'+ind.INVENTSIZEID 
				ELSE '' 
			END + 
			CASE 
				WHEN ind.INVENTCOLORID<>'' AND ind.INVENTCOLORID IS NOT NULL THEN '_'+ind.INVENTCOLORID 
				ELSE '' 
			END +
			CASE 
				WHEN ind.INVENTSTYLEID<>'' AND ind.INVENTSTYLEID IS NOT NULL THEN '_'+ind.INVENTSTYLEID 
				ELSE '' 
			END)																									AS item_no,
		COALESCE(cv.EXTERNALITEMID, cv_allblank.EXTERNALITEMID, '') AS original_item_no, ISNULL(erpt_prod.NAME, '') AS name, --Nafnabreyting 28.04.2020 HÞÖ
		ISNULL(ips.LEADTIME,0)																						AS purchase_lead_time_days,
		CASE 
			WHEN ISNULL(CAST(ips.MULTIPLEQTY AS DECIMAL(18,4)),0) < 1 THEN 1 
			ELSE ISNULL(CAST(ips.MULTIPLEQTY AS DECIMAL(18,4)),0)  
		END																											AS order_multiple,
		CAST(itm2.PRICE AS DECIMAL(18,4)) / (CASE 
													WHEN CAST(itm2.PRICEUNIT AS DECIMAL(18,4)) = 0 THEN 1 
													ELSE CAST(itm2.PRICEUNIT AS DECIMAL(18,4)) 
												END)																AS purchase_price,
		CAST(ips.[LOWESTQTY] AS DECIMAL(18,4))																		AS min_order_qty,
		ISNULL(erpt_prod.[DESCRIPTION], '')																			AS [description],
		CAST(0 AS BIT)																								AS closed, 
		CAST(it.[NETWEIGHT] AS [DECIMAL](18, 4))																	AS [weight],
		ISNULL(reqdim.[MININVENTONHAND], 0)  *ISNULL(reqdim.MIN_SAFETYFACTOR, 1)									AS min_stock, 
		reqdim.MAXINVENTONHAND * ISNULL(reqdim.MAX_SAFETYFACTOR, 1)													AS max_stock,
		CAST(it.[UNITVOLUME] AS [DECIMAL](18, 4))																	AS [volume], 
		CAST(ISNULL(pdt.AMOUNT, 0) AS DECIMAL(18, 4))																AS sale_price, 
		CAST(ISNULL(itm2.PRICE, 0) AS DECIMAL(18, 4))																AS cost_price,
		IIF(it.REQGROUPID NOT LIKE '%[0-9]%',NULL,it.REQGROUPID)													AS order_frequency_days,
		NULL																										AS extra_safety_stock, 
		NULL																										AS wastage_days,
		CAST(ISNULL(pallet.FACTOR, it.BYKSTANDARDPALLETQUANTITY) AS DECIMAL(18,4))									AS [QTY_PALLET],
		it.ITEMBUYERGROUPID																							AS responsible, 
		COALESCE(cv.CUSTVENDRELATION, it.PRIMARYVENDORID)															AS vendor,
		ecrpr.CATEGORY																								AS category
	FROM
		(
			SELECT ral.ASSORTMENTID AS ASSORTMENTID, ral.PRODUCTID AS PRODUCT, ISNULL(variant.[RECID], ral.VARIANTID) AS VARIANT, rat.VALIDFROM AS VALIDFROM, rat.VALIDTO AS VALIDTO, rat.[STATUS], ralc.OMOPERATINGUNITID AS OMOPERATINGUNITID, store.INVENTLOCATION AS INVENTLOCATION, store.CHANNELTYPE AS CHANNELTYPE, ral.[PARTITION] AS [PARTITION]
			FROM ax_cus.RETAILASSORTMENTLOOKUP ral
				INNER JOIN ax_cus.RETAILASSORTMENTLOOKUPCHANNELGROUP ralc	ON ral.ASSORTMENTID=ralc.ASSORTMENTID AND(ral.[PARTITION]=ralc.[PARTITION])
				INNER JOIN ax_cus.RETAILCHANNELTABLE store				ON ralc.OMOPERATINGUNITID=store.OMOPERATINGUNITID AND store.[PARTITION]=ral.[PARTITION]
				INNER JOIN ax.RETAILASSORTMENTTABLE rat					ON rat.RECID=ral.ASSORTMENTID AND rat.[PARTITION]=ral.[PARTITION]
				LEFT JOIN ax.ECORESPRODUCT variant						ON variant.[PRODUCTMASTER]=ral.PRODUCTID AND ral.VARIANTID=0 AND variant.[PARTITION]=ral.[PARTITION]
			GROUP BY ral.ASSORTMENTID, ral.PRODUCTID, ISNULL(variant.[RECID], ral.VARIANTID), rat.VALIDFROM, rat.VALIDTO, rat.[STATUS], ral.[PARTITION], ralc.OMOPERATINGUNITID, store.INVENTLOCATION, store.CHANNELTYPE
			HAVING(MIN(ral.LINETYPE)=1) --Filter out excluded items and variants
		) products
		INNER JOIN ax_cus.ECORESPRODUCTCATEGORY ecrpr		ON products.PRODUCT=ecrpr.PRODUCT AND ecrpr.[PARTITION]=products.[PARTITION]
		INNER JOIN ax_cus.INVENTTABLE it					ON it.PRODUCT=products.PRODUCT AND it.[PARTITION]=products.[PARTITION]
		LEFT JOIN ax.INVENTITEMPURCHSETUP ips				ON it.ITEMID = ips.ITEMID AND ips.DATAAREAID = it.DATAAREAID AND ips.PARTITION = it.PARTITION AND ips.INVENTDIMID = 'AllBlank'
		LEFT JOIN ax_cus.INVENTDIMCOMBINATION icomb			ON icomb.DISTINCTPRODUCTVARIANT=products.VARIANT AND icomb.[PARTITION]=products.[PARTITION] AND icomb.[DATAAREAID]=it.[DATAAREAID]
		LEFT JOIN ax.INVENTDIM ind							ON ind.INVENTDIMID=icomb.INVENTDIMID AND ind.DATAAREAID=icomb.DATAAREAID AND ind.[PARTITION]=icomb.[PARTITION]
		LEFT JOIN ax.ECORESPRODUCTTRANSLATION erpt_prod		ON products.PRODUCT=erpt_prod.PRODUCT AND products.[PARTITION]=erpt_prod.[PARTITION] AND erpt_prod.LANGUAGEID='is'
		LEFT JOIN ax.ECORESPRODUCTTRANSLATION erpt_var		ON products.VARIANT=erpt_var.PRODUCT AND erpt_var.LANGUAGEID=erpt_prod.LANGUAGEID AND products.[PARTITION]=erpt_var.[PARTITION]
		LEFT JOIN ax_cus.CUSTVENDEXTERNALITEM cv			ON it.ITEMID=cv.ITEMID AND it.DATAAREAID=cv.DATAAREAID AND it.[PARTITION]=cv.[PARTITION] AND ind.INVENTDIMID=cv.INVENTDIMID AND cv.MODULETYPE=3 AND cv.BYKVENDPRIORITY=1
		LEFT JOIN(
			SELECT ITEMID, MAX(EXTERNALITEMID) AS EXTERNALITEMID, DATAAREAID, [PARTITION]
			FROM ax_cus.CUSTVENDEXTERNALITEM
			WHERE INVENTDIMID='AllBlank' AND MODULETYPE=3 AND BYKVENDPRIORITY=1
			GROUP BY ITEMID, DATAAREAID, [PARTITION]
		) cv_allblank ON it.ITEMID=cv_allblank.ITEMID AND it.DATAAREAID=cv_allblank.DATAAREAID AND it.[PARTITION]=cv_allblank.[PARTITION]

		LEFT JOIN ax_cus.INVENTTABLEMODULE itm			ON it.[ITEMID]=itm.ITEMID AND itm.MODULETYPE=2 --2:Sales order
		LEFT JOIN ax_cus.INVENTTABLEMODULE itm2			ON it.[ITEMID]=itm2.ITEMID  AND itm2.MODULETYPE=0 --2:Purchase orders

		LEFT JOIN(SELECT DISTINCT [PRODUCT], [FACTOR], uomc.[PARTITION]
                            FROM ax_cus.[UNITOFMEASURECONVERSION] uomc
                                 JOIN ax_cus.[UNITOFMEASURE] uom_from ON uomc.[FROMUNITOFMEASURE]=uom_from.[RECID]
                                 JOIN ax_cus.[UNITOFMEASURE] uom_to ON uomc.[TOUNITOFMEASURE]=uom_to.[RECID]
                            WHERE uom_from.[SYMBOL]='Pallet' AND uom_to.[SYMBOL]='Ea') pallet ON pallet.PRODUCT=it.PRODUCT


		--	02.12.2019.JÍB: tökum söluverð úr PriceDiscTable skv. upplýsingum frá Valgeiri (AX ráðgjafa)
		LEFT JOIN (
			SELECT MAX(AMOUNT) AS AMOUNT, ITEMRELATION, INVENTDIMID, UNITID, DATAAREAID
			FROM ax_cus.PRICEDISCTABLE
			WHERE 1=1 AND ITEMCODE=0 AND ACCOUNTCODE=2 AND CURRENCY='ISK' AND((ISNULL(FROMDATE, '')='' AND ISNULL(TODATE, '')='')OR(FROMDATE<=GETDATE()AND TODATE>=GETDATE()))
			GROUP BY ITEMRELATION, INVENTDIMID, UNITID, DATAAREAID
		) pdt ON pdt.ITEMRELATION=it.ITEMID AND pdt.DATAAREAID=it.DATAAREAID AND pdt.INVENTDIMID=ISNULL(ind.INVENTDIMID, 'AllBlank') AND pdt.UNITID=itm.UNITID

		LEFT JOIN (
			SELECT 
				req.ITEMID,dim.INVENTLOCATIONID,dim.INVENTSIZEID,dim.INVENTCOLORID,dim.INVENTSTYLEID,req.INVENTLOCATIONIDREQMAIN
				, req.REQGROUPID, rg.COVTIMEFENCE, req.REQPOTYPE,req.MININVENTONHAND
				,req.MAXINVENTONHAND
				, minkey.SAFETYFACTOR AS MIN_SAFETYFACTOR
				, maxkey.SAFETYFACTOR AS MAX_SAFETYFACTOR
				,req.[PARTITION],req.DATAAREAID
			FROM ax_cus.REQITEMTABLE req
				INNER JOIN ax_cus.INVENTTABLE it	ON it.ITEMID = req.ITEMID
				INNER JOIN ax_cus.REQGROUP rg		ON rg.REQGROUPID = it.REQGROUPID
				INNER JOIN ax.INVENTDIM dim			ON dim.INVENTDIMID=req.COVINVENTDIMID AND req.[PARTITION]=dim.[PARTITION] AND req.DATAAREAID=dim.DATAAREAID
				LEFT JOIN (
					SELECT saf.SAFETYKEYID, safline.SAFETYFACTOR, saf.DATAAREAID, saf.[PARTITION]
					FROM ax_cus.REQSAFETYKEY saf
					INNER JOIN (
							SELECT [SAFETYFACTOR],[SAFETYKEYID],[DATAAREAID],[PARTITION],ROW_NUMBER() OVER(PARTITION BY [SAFETYKEYID] ORDER BY SORT1980 ASC) AS rk
							FROM ax_cus.[REQSAFETYLINE]
					) safline ON safline.SAFETYKEYID = saf.SAFETYKEYID AND saf.DATAAREAID = safline.DATAAREAID AND saf.[PARTITION] = safline.[PARTITION] AND rk = 1
				WHERE saf.[FIXEDDATE] <= GETDATE()
				) AS minkey ON minkey.SAFETYKEYID = req.MINSAFETYKEYID AND req.DATAAREAID = minkey.DATAAREAID AND req.[PARTITION] = minkey.[PARTITION]

				LEFT JOIN (
					SELECT saf.SAFETYKEYID, safline.SAFETYFACTOR, saf.DATAAREAID, saf.[PARTITION]
					FROM ax_cus.REQSAFETYKEY saf
				INNER JOIN (
					SELECT [SAFETYFACTOR],[SAFETYKEYID],[DATAAREAID],[PARTITION],ROW_NUMBER() OVER(PARTITION BY [SAFETYKEYID] ORDER BY SORT1980 ASC) AS rk
					FROM ax_cus.[REQSAFETYLINE]
				) safline ON safline.SAFETYKEYID = saf.SAFETYKEYID AND saf.DATAAREAID = safline.DATAAREAID AND saf.[PARTITION] = safline.[PARTITION] AND rk = 1
			WHERE saf.[FIXEDDATE] <= GETDATE()
			) AS maxkey ON maxkey.SAFETYKEYID = req.MAXSAFETYKEYID AND req.DATAAREAID = maxkey.DATAAREAID AND req.[PARTITION] = maxkey.[PARTITION]

		GROUP BY 
			req.ITEMID,dim.INVENTLOCATIONID,dim.INVENTSIZEID,dim.INVENTCOLORID,dim.INVENTSTYLEID,req.INVENTLOCATIONIDREQMAIN
			, req.REQGROUPID, rg.COVTIMEFENCE,req.REQPOTYPE,req.MININVENTONHAND,req.MAXINVENTONHAND,req.[PARTITION],req.DATAAREAID,minkey.SAFETYFACTOR,maxkey.SAFETYFACTOR
		HAVING req.REQPOTYPE = MAX(req.REQPOTYPE) --(1:Purchase order, 1:Production, 2:Transfer, 3:Kanban)

	) reqdim ON it.[ITEMID] = reqdim.ITEMID  AND ind.INVENTSIZEID=reqdim.INVENTSIZEID --AND reqdim.INVENTLOCATIONID = loc.location_no

	WHERE 
		products.CHANNELTYPE=0 -- (0:RetailStore, 1:OnlineStore, 2:OnlineMarketPlace, 3:SharePointOnlineStore, 4:MCRCallCenter) 
		AND products.[STATUS]=1 -- (0:Draft, 1:Published)
		AND GETDATE() BETWEEN products.VALIDFROM AND products.VALIDTO 
		AND it.DATAAREAID			= 'byko' -- getfunction
		AND products.PARTITION	= '5637144576' -- get from core.setting
)
SELECT
	CAST(c.item_no AS NVARCHAR(255)) AS NO,
	CAST(c.name AS NVARCHAR(255)) AS NAME,
	CAST(c.description AS NVARCHAR(255)) AS DESCRIPTION,
	CAST(IIF(c.vendor = '', '-99', c.vendor) AS NVARCHAR(255)) AS PRIMARY_VENDOR_NO,
	CAST(c.purchase_lead_time_days AS NVARCHAR(255)) AS PURCHASE_LEAD_TIME_DAYS,
	CAST(NULL AS SMALLINT) AS TRANSFER_LEAD_TIME_DAYS,
    CAST(c.order_frequency_days AS SMALLINT) AS ORDER_FREQUENCY_DAYS,
    CAST(NULL AS SMALLINT) AS ORDER_COVERAGE_DAYS,
	CAST(c.min_order_qty AS DECIMAL(18,4)) AS MIN_ORDER_QTY,
    CAST(c.original_item_no AS NVARCHAR(50)) AS ORIGINAL_NO,
    CAST(c.closed AS BIT) AS [CLOSED],
    CAST(0 AS BIT) AS [CLOSED_FOR_ORDERING],
	CAST(c.responsible AS NVARCHAR(255)) AS [RESPONSIBLE],
    CAST(c.sale_price AS DECIMAL(18,4)) AS [SALE_PRICE],
    CAST(c.cost_price AS DECIMAL(18,4)) AS [COST_PRICE],
    CAST(c.purchase_price AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
    CAST(c.order_multiple AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
    CAST(c.QTY_PALLET AS DECIMAL(18,4)) AS [QTY_PALLET],
    CAST(c.volume AS DECIMAL(18,4)) AS [VOLUME],
    CAST(c.weight AS DECIMAL(18,4)) AS [WEIGHT],
    CAST(c.min_stock AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
    CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
    CAST(c.max_stock AS DECIMAL(18,4)) AS [MAX_STOCK],
	CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN c.category
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN h1.parent_category
			WHEN h4.parent_category IS NULL THEN h2.parent_category
		ELSE h3.category END AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
	CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN c.category
			WHEN h4.parent_category IS NULL THEN h1.parent_category
		ELSE h2.category END AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
	CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL THEN c.category
			ELSE h1.category END AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
    CAST(NULL AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
    CAST(NULL AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
    CAST(1 AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
    CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
    CAST(0 AS BIT) AS [SPECIAL_ORDER],
    CAST(0 AS BIT) AS [INCLUDE_IN_AGR]

FROM
	cte c
	LEFT JOIN ax_cus.v_item_group_hierarchy h1 ON c.category = h1.category
	LEFT JOIN ax_cus.v_item_group_hierarchy h2 ON h2.category = h1.parent_category
	LEFT JOIN ax_cus.v_item_group_hierarchy h3 ON h3.category = h2.parent_category
	LEFT JOIN ax_cus.v_item_group_hierarchy h4 ON h4.category = h3.parent_category
WHERE 
	h2.category IS NOT NULL					-- 02.02.2024.GH	Something makes this give multiple lines but only 1 row per item no has group level 2, 3 and 4

