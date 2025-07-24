
CREATE VIEW [ax_cus].[v_ITEM] AS

	   SELECT DISTINCT
        CAST(fi.ITEMID AS NVARCHAR(255))                                                                                                                    AS [NO],
        CAST(COALESCE(TRIM(erpt.NAME), TRIM(fi.NAMEALIAS)) AS NVARCHAR(255))                                                                                AS [NAME],
        CAST(fi.NAMEALIAS AS NVARCHAR(1000))                                                                                                                AS [DESCRIPTION],
		CASE 
			WHEN NOT EXISTS (SELECT 1 FROM [ax].VENDTABLE v WHERE v.ACCOUNTNUM = fi.PRIMARYVENDORID) THEN CAST('vendor_missing' AS NVARCHAR(255))
			ELSE IIF(fi.PRIMARYVENDORID='', CAST('vendor_missing' AS NVARCHAR(255)),CAST( fi.PRIMARYVENDORID AS NVARCHAR(255))) 
		                                                                                                                                                END AS [PRIMARY_VENDOR_NO],
        CAST(ISNULL(ips.LEADTIME,0) AS SMALLINT)                                                                                                            AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)                                                                                                                              AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT )                                                                                                                             AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT )                                                                                                                             AS [ORDER_COVERAGE_DAYS],
        CAST(ips.[LOWESTQTY] AS DECIMAL(18,4))                                                                                                              AS [MIN_ORDER_QTY],
        CAST(ISNULL(cv.EXTERNALITEMID, '') AS NVARCHAR(50))                                                                                                 AS [ORIGINAL_NO],
        CAST(0 AS BIT)                                                                                                                                      AS [CLOSED_FOR_ORDERING],
        CAST(ibg.DESCRIPTION AS NVARCHAR(255))                                                                                                          AS [RESPONSIBLE],
        CAST(itm.PRICE AS DECIMAL(18,4))                                                                                                                    AS [SALE_PRICE],
        CAST(itm.PRICE AS DECIMAL(18,4)) / (CASE WHEN CAST(itm.PRICEUNIT AS DECIMAL(18,4)) = 0 THEN 1 ELSE CAST(itm.PRICEUNIT AS DECIMAL(18,4)) END)        AS [COST_PRICE],
        CAST(itm2.PRICE AS DECIMAL(18,4)) / (CASE WHEN CAST(itm2.PRICEUNIT AS DECIMAL(18,4)) = 0 THEN 1 ELSE CAST(itm2.PRICEUNIT AS DECIMAL(18,4)) END)     AS [PURCHASE_PRICE],
        CASE WHEN ISNULL(CAST(ips.MULTIPLEQTY AS DECIMAL(18,4)),0) < 1 THEN 1 ELSE ISNULL(CAST(ips.MULTIPLEQTY AS DECIMAL(18,4)),0)                     END AS [ORDER_MULTIPLE],
        CAST(ISNULL(fi.CEPALLETQTY,1) AS DECIMAL(18,4))                                                                                                                         AS [QTY_PALLET],
        CAST(fi.UNITVOLUME AS DECIMAL(18,6))                                                                                                                AS [VOLUME],
        CAST(fi.NETWEIGHT AS DECIMAL(18,6))                                                                                                                 AS [WEIGHT],
        CAST(0 AS DECIMAL(18,4))                                                                                                                            AS [MIN_STOCK],
        CAST(ISNULL(RQ.MININVENTONHAND,0) AS DECIMAL(18,4))                                                                                                 AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))                                                                                                                         AS [MIN_DISPLAY_STOCK],

        CAST(CASE 
			WHEN RQ.MAXINVENTONHAND = 0 THEN NULL 
			ELSE RQ.MAXINVENTONHAND
			END AS DECIMAL(18,4))                                                                                                                         AS [MAX_STOCK],
		CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN igg.category
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN h1.parent_category
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN h2.parent_category
			WHEN h4.parent_category IS NULL THEN h3.parent_category
			ELSE h4.category END AS NVARCHAR(255)) AS ITEM_GROUP_NO_LVL_1,
		CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN igg.category
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN h1.parent_category
			WHEN h4.parent_category IS NULL THEN h2.parent_category
			ELSE h3.category END AS NVARCHAR(255)) AS ITEM_GROUP_NO_LVL_2,
		CAST(CASE
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN NULL
			WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN igg.category
			WHEN h4.parent_category IS NULL THEN h1.parent_category
			ELSE h2.category END AS NVARCHAR(255)) AS ITEM_GROUP_NO_LVL_3,
        CAST(NULL AS NVARCHAR(50))                                                                                                                          AS [BASE_UNIT_OF_MEASURE],
        CAST(NULL AS NVARCHAR(50))                                                                                                                          AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(1 AS DECIMAL(18,4))                                                                                                                            AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS BIT)                                                                                                                                      AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4))                                                                                                                            AS [REORDER_POINT],
		CAST(1 AS BIT)                                                                                                                                      AS [INCLUDE_IN_AGR],
		CAST(CASE WHEN ips.STOPPED = 1 THEN 1
			WHEN fi.SPAFACTOR = 6 THEN 1 
			ELSE 0 END AS BIT)                                                                                                                           AS [CLOSED], --Vörur með spástuðul G eru lokaðar, a=0 b=1 o.s.frv
        CAST(fi.DATAAREAID AS NVARCHAR(4))                                                                                                                  AS [COMPANY]
    FROM ax_cus.INVENTTABLE fi
INNER JOIN [ax].ECORESPRODUCT erp ON fi.PRODUCT = erp.RECID AND fi.PARTITION = erp.PARTITION
LEFT JOIN [ax].ECORESPRODUCTTRANSLATION erpt ON erp.RECID = erpt.PRODUCT AND erp.PARTITION = erpt.PARTITION AND erpt.LANGUAGEID = (SELECT TOP(1) language FROM ax.Companies cies WHERE cies.company = fi.DATAAREAID)
LEFT JOIN [ax].VENDTABLE v ON fi.PRIMARYVENDORID = v.ACCOUNTNUM AND v.DATAAREAID = fi.DATAAREAID AND v.PARTITION = fi.PARTITION
LEFT JOIN [ax].INVENTITEMPURCHSETUP ips ON fi.ITEMID = ips.ITEMID AND ips.DATAAREAID = fi.DATAAREAID AND ips.PARTITION = fi.PARTITION
LEFT JOIN [ax].CUSTVENDEXTERNALITEM cv ON fi.ITEMID = cv.ITEMID AND fi.PRIMARYVENDORID = cv.CUSTVENDRELATION AND cv.DATAAREAID = fi.DATAAREAID AND cv.PARTITION = fi.PARTITION AND cv.MODULETYPE = 3 -- Moduletype = 'ALL'
LEFT JOIN ax_cus.INVENTTABLEMODULE itm ON fi.ITEMID = itm.ITEMID AND itm.DATAAREAID = fi.DATAAREAID AND itm.PARTITION = fi.PARTITION AND itm.MODULETYPE = 2 -- Moduletype = 'Sales'
LEFT JOIN ax_cus.INVENTTABLEMODULE itm2 ON fi.ITEMID = itm2.ITEMID AND itm2.DATAAREAID = fi.DATAAREAID AND itm2.PARTITION = fi.PARTITION AND itm2.MODULETYPE = 1 -- Moduletype = 'Purchases'
LEFT JOIN [ax].INVENTITEMINVENTSETUP iis ON fi.ITEMID = iis.ITEMID AND iis.DATAAREAID = fi.DATAAREAID AND iis.PARTITION = fi.PARTITION
LEFT JOIN [ax].INVENTITEMGROUPITEM ivg ON ivg.ITEMID = fi.ITEMID AND ivg.ITEMDATAAREAID = fi.DATAAREAID AND ivg.PARTITION = fi.PARTITION
LEFT OUTER JOIN ax_cus.INVENTBUYERGROUP ibg ON fi.ITEMBUYERGROUPID = ibg.GROUP_ AND fi.DATAAREAID = ibg.DATAAREAID
LEFT OUTER JOIN ax.ReqItemTable rq ON rq.DATAAREAID = fi.DATAAREAID AND rq.PARTITION = fi.PARTITION AND rq.ITEMID = fi.ITEMID
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
		ON igg.PRODUCT = fi.PRODUCT
        		AND igg.grouppriority = 1
LEFT OUTER JOIN ax_cus.v_item_group_hierarchy h1 ON igg.category = h1.category
LEFT OUTER JOIN ax_cus.v_item_group_hierarchy h2 ON h2.category = h1.parent_category
LEFT OUTER JOIN ax_cus.v_item_group_hierarchy h3 ON h3.category = h2.parent_category
LEFT OUTER JOIN ax_cus.v_item_group_hierarchy h4 ON h4.category = h3.parent_category
WHERE ips.INVENTDIMID = 'AllBlank' AND ISNULL(iis.STOPPED, 0) = 0

