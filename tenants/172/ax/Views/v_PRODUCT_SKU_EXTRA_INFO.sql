CREATE VIEW [ax_cus].[v_PRODUCT_SKU_EXTRA_INFO]

AS
SELECT DISTINCT
        CAST(it.[ITEMID] AS NVARCHAR(255)) AS [NO],
        CAST('Myl' AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(reqdim.INVENTSIZEID AS NVARCHAR(50)) AS SIZE_NO,
        CAST(reqdim.INVENTCOLORID AS NVARCHAR(50)) AS COLOUR_NO,
        CAST(reqdim.INVENTSTYLEID AS NVARCHAR(50)) AS STYLE_NO,
		igg.CATEGORY AS CATEGORY,
			CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN igg.CATEGORY 
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN h1.parent_category
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN h2.parent_category
			WHEN h4.parent_category IS NULL THEN h3.parent_category
			ELSE h4.category END AS NVARCHAR(255)) AS PRODUCT_GROUP_NO_LEVEL_1,
		CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN igg.CATEGORY 
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN h1.parent_category
			WHEN h4.parent_category IS NULL THEN h2.parent_category
			ELSE h3.category END AS NVARCHAR(255)) AS PRODUCT_GROUP_NO_LEVEL_2,
		CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN igg.CATEGORY 
			WHEN h4.parent_category IS NULL THEN h1.parent_category
			ELSE h2.category END AS NVARCHAR(255)) AS PRODUCT_GROUP_NO_LEVEL_3,
		CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL THEN igg.CATEGORY 
			ELSE h1.category END AS NVARCHAR(255)) AS PRODUCT_GROUP_NO_LEVEL_4,
        -- add more columns here, the "column" is only there as an example
        CAST(NULL AS INT) AS [column]
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
				and req.DATAAREAID=dim.DATAAREAID
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

	LEFT JOIN ax.INVENTTABLEMODULE itm 
		ON it.[ITEMID] = itm.ItemId 
		AND itm.ModuleType = 2 --2:Sales order

	LEFT OUTER JOIN ax_cus.INVENTITEMPURCHSETUP IPS
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
			AND DATAAREAID =  'mfk' 
			GROUP BY ITEMRELATION) price
		ON it.ITEMID = price.ITEMRELATION
	LEFT OUTER JOIN (select ROW_NUMBER() over (partition by DATAAREAID,PARTITION,ITEMID order by COVINVENTDIMID desc) row_count --Bara gert til að fá einkvæm gildi
						,DATAAREAID
						,PARTITION
						,ITEMID
						,COVINVENTDIMID
						,MAXINVENTONHAND
						,MININVENTONHAND
						,COVPERIOD
						from ax_cus.REQITEMTABLE) AS RQ
		ON RQ.ITEMID = it.ITEMID
		AND RQ.row_count = 1
   LEFT OUTER JOIN ax_cus.v_item_group_hierarchy h1 ON igg.category = h1.category
		LEFT OUTER JOIN ax_cus.v_item_group_hierarchy h2 ON h2.category = h1.parent_category
		LEFT OUTER JOIN ax_cus.v_item_group_hierarchy h3 ON h3.category = h2.parent_category
		LEFT OUTER JOIN ax_cus.v_item_group_hierarchy h4 ON h4.category = h3.parent_category
	CROSS JOIN ax_cus.v_LOCATION l
	WHERE l.[NO] = 'Myl'


