

CREATE VIEW [ax_cus].[v_ITEM] AS

	   SELECT DISTINCT
        CAST(it.[ITEMID] AS NVARCHAR(255))                                                                                                                  AS [NO],
        CAST(ISNULL(erpt_prod.NAME,it.NAMEALIAS) AS NVARCHAR(255))																							AS [NAME],
        CAST(ISNULL(erpt_prod.[Description], it.NAMEALIAS) AS NVARCHAR(1000))                                                                               AS [DESCRIPTION],
		CAST(CASE WHEN it.PRIMARYVENDORID = '' THEN 'vendor_missing' 
			ELSE it.PRIMARYVENDORID 
			END AS NVARCHAR(255))																															AS [PRIMARY_VENDOR_NO],
        CAST(NULL AS SMALLINT)																																AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)                                                                                                                              AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)																																AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT )                                                                                                                             AS [ORDER_COVERAGE_DAYS],
        CAST(NULL AS DECIMAL(18,4))																															AS [MIN_ORDER_QTY],
        CAST(ISNULL(cv.EXTERNALITEMID, '') AS NVARCHAR(50))                                                                                                 AS [ORIGINAL_NO],
        CAST(0 AS BIT)                                                                                                                                      AS [CLOSED_FOR_ORDERING],
        CAST(ibg.DESCRIPTION AS NVARCHAR(1000))																												AS [RESPONSIBLE],
        CAST(COALESCE(price.amount,itm.Price,0) AS [DECIMAL](18, 4))                                                                                        AS [SALE_PRICE],
        CAST(ISNULL(itm.PRICE,0) AS DECIMAL(18,4))																											AS [COST_PRICE],
		CAST(NULL AS DECIMAL(18,4))																															AS [PURCHASE_PRICE],
        CAST(NULL AS DECIMAL(18,4))																															AS ORDER_MULTIPLE,
        CAST(ISNULL(it.CEPALLETQTY,1) AS INT)                                                                                                               AS [QTY_PALLET],
        CASE
		WHEN it.AGRPURCHQTY = 0 THEN CAST(it.[UNITVOLUME] AS [DECIMAL](18, 4))
		ELSE CAST((it.[AGRLENGTH] * it.[AGRWIDTH] * it.[AGRHEIGHT] / it.[AGRPURCHQTY]) AS [DECIMAL](18, 4))
		END																																					AS [VOLUME],
        CAST(it.NETWEIGHT AS DECIMAL(18, 4))																												AS [WEIGHT],
        CAST(ISNULL(RQ.MININVENTONHAND,0) AS DECIMAL(18,4))                                                                                                 AS [MIN_STOCK],

        CAST(0 AS DECIMAL(18,4))                                                                                                                            AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))                                                                                                                         AS [MIN_DISPLAY_STOCK],

        CAST(CASE 
			WHEN RQ.MAXINVENTONHAND = 0 THEN NULL 
			ELSE RQ.MAXINVENTONHAND
			END AS DECIMAL(18,4))																															AS [MAX_STOCK],
        CAST(NULL AS NVARCHAR(255))																															AS [ITEM_GROUP_NO_LVL_1],
        CAST(NULL AS NVARCHAR(255))                                                                                                                         AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255))                                                                                                                         AS [ITEM_GROUP_NO_LVL_3],
        CAST(NULL AS NVARCHAR(50))                                                                                                                          AS [BASE_UNIT_OF_MEASURE],
        CAST(NULL AS NVARCHAR(50))                                                                                                                          AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(NULL AS DECIMAL(18,4))                                                                                                                         AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS BIT)                                                                                                                                      AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4))                                                                                                                            AS [REORDER_POINT],
		CAST(1 AS BIT)                                                                                                                                      AS [INCLUDE_IN_AGR],
		CAST(CASE
			WHEN IPS.STOPPED = 1 THEN 1
			WHEN it.SPAFACTOR = 6 THEN 1 
			ELSE 0 END
			AS BIT)																																			AS [CLOSED],
        CAST(it.DATAAREAID AS NVARCHAR(4))                                                                                                                  AS [COMPANY]
    FROM (
		 SELECT 
			erp.RECID AS PRODUCT,
			NULL AS VARIANT,
			erp.[PARTITION],
			erp.PRODUCTTYPE
		 FROM ax_cus.ECORESPRODUCT erp 
		 WHERE erp.[PRODUCTMASTER] IS NULL AND erp.PRODUCTTYPE = 1
	) products
	INNER JOIN ax_cus.INVENTTABLE it 
		ON it.PRODUCT = products.PRODUCT 
		AND it.[PARTITION] = products.[PARTITION]

	LEFT JOIN (
			SELECT req.ITEMID,dim.INVENTLOCATIONID,dim.INVENTSIZEID,dim.INVENTCOLORID,
					dim.INVENTSTYLEID,req.INVENTLOCATIONIDREQMAIN, req.LEADTIMETRANSFER, 
					req.LEADTIMEPURCHASE, req.[LEADTIMEPURCHASEACTIVE], req.[LEADTIMETRANSFERACTIVE], 
					req.REQPOTYPE,req.REQPOTYPEACTIVE,req.MININVENTONHAND,req.MAXINVENTONHAND,req.VENDID,
					req.ITEMCOVFIELDSACTIVE,req.[PARTITION],req.DATAAREAID
			FROM ax_cus.REQITEMTABLE req
			INNER JOIN ax_cus.INVENTDIM dim 
				ON dim.INVENTDIMID=req.COVINVENTDIMID 
				AND req.[PARTITION]=dim.[PARTITION] 
				AND req.DATAAREAID=dim.DATAAREAID
			GROUP BY req.ITEMID,dim.INVENTLOCATIONID,dim.INVENTSIZEID,
				dim.INVENTCOLORID,dim.INVENTSTYLEID,req.INVENTLOCATIONIDREQMAIN, 
				req.LEADTIMETRANSFER, req.LEADTIMEPURCHASE, req.[LEADTIMEPURCHASEACTIVE], 
				req.[LEADTIMETRANSFERACTIVE], req.REQPOTYPE,req.REQPOTYPEACTIVE,req.MININVENTONHAND,
				req.MAXINVENTONHAND,req.VENDID,req.ITEMCOVFIELDSACTIVE,req.[PARTITION],req.DATAAREAID
			HAVING REQPOTYPE = MAX(REQPOTYPE) --(1:Purchase order, 1:Production, 2:Transfer, 3:Kanban)

		) reqdim 
		ON it.ITEMID = reqdim.ITEMID 

	LEFT OUTER JOIN ax_cus.INVENTBUYERGROUP ibg 
		ON it.ITEMBUYERGROUPID = ibg.GROUP_ 
		AND it.DATAAREAID = ibg.DATAAREAID

	LEFT OUTER JOIN (
			SELECT ecg.RECID, 
					pc.PRODUCT,
					ep.DISPLAYPRODUCTNUMBER, 
					pc.CATEGORY,
					ROW_NUMBER() OVER (PARTITION BY pc.product, ep.DISPLAYPRODUCTNUMBER ORDER BY LEVEL_ DESC) grouppriority
			FROM ax_cus.ECORESPRODUCTCATEGORY pc 
			JOIN ax_cus.ECORESCATEGORY ecg 
				ON ecg.RECID = pc.CATEGORY
			JOIN ax_cus.ECORESPRODUCT ep
				ON ep.RECID = pc.PRODUCT
		) igg 
		ON igg.PRODUCT = it.PRODUCT 
		AND grouppriority = 1

	LEFT OUTER JOIN ax.ECORESPRODUCTTRANSLATION erpt_prod 
		ON  products.PRODUCT = erpt_prod.PRODUCT 
		AND products.[PARTITION] = erpt_prod.[PARTITION] 
		AND erpt_prod.LanguageId = 'is'

	LEFT JOIN ax.CustVendExternalItem cv 
		ON it.ITEMID = cv.ITEMID 
		AND it.primaryvendorid = cv.CUSTVENDRELATION 
		AND it.DATAAREAID = cv.DATAAREAID 
		AND it.[PARTITION] = cv.[PARTITION]  
		AND cv.MODULETYPE = 3

	LEFT JOIN ax_cus.INVENTTABLEMODULE itm 
		ON it.[ITEMID] = itm.ItemId 
		AND itm.ModuleType = 2 --2:Sales order

	LEFT OUTER JOIN ax.INVENTITEMPURCHSETUP IPS
		ON it.ITEMID = IPS.itemid
		AND cv.DATAAREAID = IPS.DATAAREAID
		AND 'AllBlank' = IPS.INVENTDIMID


	LEFT OUTER JOIN ( 
			SELECT ITEMRELATION, MAX(AMOUNT) AMOUNT 
			FROM ax_cus.PRICEDISCTABLE
			WHERE RELATION = 4
			AND MODULE = 1
			AND ACCOUNTCODE = 2
			AND GETDATE() BETWEEN FROMDATE AND TODATE
			AND DATAAREAID =  'ism' 
			GROUP BY ITEMRELATION) price
		ON it.ITEMID = price.ITEMRELATION
	LEFT OUTER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY DATAAREAID,PARTITION,ITEMID ORDER BY COVINVENTDIMID DESC) row_count --Bara gert til að fá einkvæm gildi
						,DATAAREAID
						,PARTITION
						,ITEMID
						,COVINVENTDIMID
						,MAXINVENTONHAND
						,MININVENTONHAND
						,COVPERIOD
						FROM ax_cus.REQITEMTABLE) AS RQ
		ON RQ.ITEMID = it.ITEMID
		AND RQ.row_count = 1

	CROSS JOIN ax.v_LOCATION l

