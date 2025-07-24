

CREATE VIEW [ax_cus].[v_ITEM] AS

WITH item_data AS (SELECT DISTINCT CAST(
                                     fi.ITEMID
                                         + CASE
                                               WHEN ind.INVENTSIZEID <> '' AND ind.INVENTSIZEID IS NOT NULL
                                                   THEN '_' + ind.INVENTSIZEID
                                               ELSE '' END
                                         + CASE
                                               WHEN ind.INVENTCOLORID <> '' AND ind.INVENTCOLORID IS NOT NULL
                                                   THEN '_' + ind.INVENTCOLORID
                                               ELSE '' END
                                         + CASE
                                               WHEN ind.INVENTSTYLEID <> '' AND ind.INVENTSTYLEID IS NOT NULL
                                                   THEN '_' + ind.INVENTSTYLEID
                                               ELSE '' END
                                 AS NVARCHAR(255)
                             )                                                                                          AS [NO],
                             --CAST(TRIM(fi.NAMEALIAS) AS NVARCHAR(255))                                                  AS [NAME],
							 CAST(ISNULL(erpt_prod.NAME,'') AS NVARCHAR(255))											AS [NAME],
                             CAST(ISNULL(erpt_prod.[DESCRIPTION], '') AS NVARCHAR(1000))                                AS [DESCRIPTION],
                             CASE
                                 WHEN NOT EXISTS (SELECT 1
                                                  FROM [ax_cus].VENDTABLE v
                                                  WHERE v.ACCOUNTNUM = fi.PRIMARYVENDORID)
                                     THEN CAST('vendor_missing' AS NVARCHAR(255))
                                 ELSE IIF(fi.PRIMARYVENDORID = '', CAST('vendor_missing' AS NVARCHAR(255)),
                                          CAST(fi.PRIMARYVENDORID AS NVARCHAR(255)))
                                 END                                                                                    AS [PRIMARY_VENDOR_NO],
                             CAST(ISNULL(ips.LEADTIME, 0) AS SMALLINT)                                                  AS [PURCHASE_LEAD_TIME_DAYS],
                             CAST(NULL AS SMALLINT)                                                                     AS [TRANSFER_LEAD_TIME_DAYS],
                             CAST(NULL AS SMALLINT)                                                                     AS [ORDER_FREQUENCY_DAYS],
                             CAST(NULL AS SMALLINT)                                                                     AS [ORDER_COVERAGE_DAYS],
                             CAST(ips.[LOWESTQTY] AS DECIMAL(18, 4))                                                    AS [MIN_ORDER_QTY],
                             CAST(COALESCE(cv.EXTERNALITEMID, cv_allblank.EXTERNALITEMID, '') AS NVARCHAR(50))          AS [ORIGINAL_NO],
                             CAST(0 AS BIT)                                                                             AS [CLOSED_FOR_ORDERING],
                             CAST(fi.ITEMBUYERGROUPID AS NVARCHAR(255))                                                 AS [RESPONSIBLE],
                             CAST(itm.PRICE AS DECIMAL(18, 4))                                                          AS [SALE_PRICE],
                             CAST(itm.PRICE AS DECIMAL(18, 4)) / (CASE
                                                                      WHEN CAST(itm.PRICEUNIT AS DECIMAL(18, 4)) = 0
                                                                          THEN 1
                                                                      ELSE CAST(itm.PRICEUNIT AS DECIMAL(18, 4)) END)   AS [COST_PRICE],
                             CAST(itm2.PRICE AS DECIMAL(18, 4)) / (CASE
                                                                       WHEN CAST(itm2.PRICEUNIT AS DECIMAL(18, 4)) = 0
                                                                           THEN 1
                                                                       ELSE CAST(itm2.PRICEUNIT AS DECIMAL(18, 4)) END) AS [PURCHASE_PRICE],
                             CASE
                                 WHEN ISNULL(CAST(ips.MULTIPLEQTY AS DECIMAL(18, 4)), 0) < 1 THEN 1
                                 ELSE ISNULL(CAST(ips.MULTIPLEQTY AS DECIMAL(18, 4)), 0) END                            AS [ORDER_MULTIPLE],
                             CAST(NULL AS DECIMAL(18, 4))                                                               AS [QTY_PALLET],
                             CAST(fi.UNITVOLUME AS DECIMAL(18, 6))                                                      AS [VOLUME],
                             CAST(fi.NETWEIGHT AS DECIMAL(18, 6))                                                       AS [WEIGHT],
                             CAST(0 AS DECIMAL(18, 4))                                                                  AS [MIN_STOCK],

                             CAST(0 AS DECIMAL(18, 4))                                                                  AS [SAFETY_STOCK_UNITS],
                             CAST(NULL AS DECIMAL(18, 4))                                                               AS [MIN_DISPLAY_STOCK],

                             CAST(NULL AS DECIMAL(18, 4))                                                               AS [MAX_STOCK],
                             CAST(ivg.ITEMGROUPID AS NVARCHAR(255))                                                     AS [ITEM_GROUP_NO_LVL_1],
                             CAST(NULL AS NVARCHAR(255))                                                                AS [ITEM_GROUP_NO_LVL_2],
                             CAST(NULL AS NVARCHAR(255))                                                                AS [ITEM_GROUP_NO_LVL_3],
                             CAST(NULL AS NVARCHAR(50))                                                                 AS [BASE_UNIT_OF_MEASURE],
                             CAST(NULL AS NVARCHAR(50))                                                                 AS [PURCHASE_UNIT_OF_MEASURE],
                             CAST(NULL AS DECIMAL(18, 4))                                                               AS [QTY_PER_PURCHASE_UNIT],
                             CAST(0 AS BIT)                                                                             AS [SPECIAL_ORDER],
                             CAST(0 AS DECIMAL(18, 4))                                                                  AS [REORDER_POINT],
                             CAST(0 AS BIT)                                                                             AS [INCLUDE_IN_AGR],
                             CAST(CASE
                                      WHEN ips.STOPPED = 1 THEN 1
                                      WHEN itmg.MODELGROUPID = 'Mínus' THEN 1
                                      ELSE 0 END AS BIT)                                                                AS [CLOSED],
                             CAST(fi.DATAAREAID AS NVARCHAR(4))                                                         AS [COMPANY],
                             CAST(ISNULL(ind.INVENTSIZEID, '') AS NVARCHAR(255))                                        AS [SIZE_NO],
                             CAST(ISNULL(ind.INVENTCOLORID, '') AS NVARCHAR(255))                                       AS [COLOUR_NO],
                             CAST(ISNULL(ind.INVENTSTYLEID, '') AS NVARCHAR(255))                                       AS [STYLE_NO],
                             CAST(fi.ITEMID AS NVARCHAR(255))                                                           AS [No_TO_JOIN_IL],
                             ecrpr.CATEGORY AS [category]
             FROM (SELECT ral.PRODUCTID                      AS PRODUCT,
                          ISNULL(erp.[RECID], ral.VARIANTID) AS VARIANT,
                          ral.[PARTITION]                    AS [PARTITION]
                   FROM ax_cus.RETAILASSORTMENTLOOKUP ral
                            LEFT JOIN[ax_cus].ECORESPRODUCT erp
                                     ON ral.PRODUCTID = erp.PRODUCTMASTER AND erp.PARTITION = ral.PARTITION
                   GROUP BY ral.PRODUCTID, ISNULL(erp.[RECID], ral.VARIANTID), ral.[PARTITION]) AS cte
                      INNER JOIN ax_cus.ECORESPRODUCTCATEGORY ecrpr
                                 ON cte.PRODUCT = ecrpr.PRODUCT AND ecrpr.[PARTITION] = cte.[PARTITION]
                      INNER JOIN ax_cus.INVENTTABLE fi ON fi.PRODUCT = cte.PRODUCT AND fi.[PARTITION] = cte.[PARTITION]
                      INNER JOIN [ax].INVENTITEMPURCHSETUP ips
                                 ON fi.ITEMID = ips.ITEMID AND ips.DATAAREAID = fi.DATAAREAID AND
                                    ips.PARTITION = fi.PARTITION
                      INNER JOIN ax_cus.ECORESPRODUCT eco ON eco.RECID = fi.PRODUCT
                      INNER JOIN ax_cus.INVENTMODELGROUPITEM itmg ON itmg.ITEMID = fi.ITEMID
                      LEFT JOIN [ax].VENDTABLE v
                                ON fi.PRIMARYVENDORID = v.ACCOUNTNUM AND v.DATAAREAID = fi.DATAAREAID AND
                                   v.PARTITION = fi.PARTITION
                      LEFT JOIN [ax_cus].INVENTDIMCOMBINATION icomb
                                ON icomb.DISTINCTPRODUCTVARIANT = cte.VARIANT AND icomb.DATAAREAID = fi.DATAAREAID AND
                                   icomb.PARTITION = fi.PARTITION
                      LEFT JOIN [ax_cus].INVENTDIM ind
                                ON ind.INVENTDIMID = icomb.INVENTDIMID AND ind.DATAAREAID = icomb.DATAAREAID AND
                                   ind.PARTITION = icomb.PARTITION
					  LEFT JOIN ax.ECORESPRODUCTTRANSLATION erpt_prod ON erpt_prod.PRODUCT = fi.PRODUCT AND erpt_prod.PARTITION = fi.PARTITION AND erpt_prod.LANGUAGEID = 'is'
                      LEFT JOIN [ax].CUSTVENDEXTERNALITEM cv
                                ON fi.ITEMID = cv.ITEMID AND fi.PRIMARYVENDORID = cv.CUSTVENDRELATION AND
                                   cv.DATAAREAID = fi.DATAAREAID AND cv.PARTITION = fi.PARTITION AND
                                   ind.INVENTDIMID = cv.INVENTDIMID AND cv.MODULETYPE = 3 -- Moduletype = 'ALL'
                      LEFT JOIN (SELECT ITEMID, MAX(EXTERNALITEMID) AS EXTERNALITEMID, DATAAREAID, [PARTITION]
                                 FROM [ax].CUSTVENDEXTERNALITEM
                                 WHERE INVENTDIMID = 'AllBlank'
                                   AND MODULETYPE = 3
                                 GROUP BY ITEMID, DATAAREAID, [PARTITION]) cv_allblank
                                ON fi.ITEMID = cv_allblank.ITEMID AND fi.DATAAREAID = cv_allblank.DATAAREAID AND
                                   fi.PARTITION = cv_allblank.[PARTITION]
                      LEFT JOIN [ax_cus].INVENTTABLEMODULE itm
                                ON fi.ITEMID = itm.ITEMID AND itm.DATAAREAID = fi.DATAAREAID AND
                                   itm.PARTITION = fi.PARTITION AND
                                   itm.MODULETYPE = 2 -- Moduletype = 'Sales'
                      LEFT JOIN [ax_cus].INVENTTABLEMODULE itm2
                                ON fi.ITEMID = itm2.ITEMID AND itm2.DATAAREAID = fi.DATAAREAID AND
                                   itm2.PARTITION = fi.PARTITION AND
                                   itm2.MODULETYPE = 1 -- Moduletype = 'Purchases'
                      LEFT JOIN [ax].INVENTITEMINVENTSETUP iis
                                ON fi.ITEMID = iis.ITEMID AND iis.DATAAREAID = fi.DATAAREAID AND
                                   iis.PARTITION = fi.PARTITION
                      LEFT JOIN [ax].INVENTITEMGROUPITEM ivg
                                ON ivg.ITEMID = fi.ITEMID AND ivg.ITEMDATAAREAID = fi.DATAAREAID AND
                                   ivg.PARTITION = fi.PARTITION
                      LEFT JOIN (SELECT DISTINCT req.ITEMID,
                                                 dim.INVENTLOCATIONID,
                                                 dim.INVENTSIZEID,
                                                 dim.INVENTCOLORID,
                                                 dim.INVENTSTYLEID,
                                                 req.INVENTLOCATIONIDREQMAIN
                                         ,
                                                 req.REQGROUPID,
                                                 req.REQPOTYPE,--req.MININVENTONHAND
                                                 --,req.MAXINVENTONHAND, --minkey.SAFETYFACTOR AS MIN_SAFETYFACTOR, maxkey.SAFETYFACTOR AS MAX_SAFETYFACTOR,
                                                 req.[PARTITION],
                                                 req.DATAAREAID
                                 FROM ax_cus.REQITEMTABLE req
                                          INNER JOIN ax_cus.INVENTTABLE it ON it.ITEMID = req.ITEMID
                                          INNER JOIN ax_cus.INVENTDIM dim ON dim.INVENTDIMID = req.COVINVENTDIMID AND
                                                                             req.[PARTITION] = dim.[PARTITION] AND
                                                                             req.DATAAREAID = dim.DATAAREAID AND
                                                                             dim.INVENTSITEID = '01'
                                 GROUP BY req.ITEMID, dim.INVENTLOCATIONID, dim.INVENTSIZEID, dim.INVENTCOLORID,
                                          dim.INVENTSTYLEID,
                                          req.INVENTLOCATIONIDREQMAIN, req.REQGROUPID, req.REQPOTYPE,--req.MININVENTONHAND,req.MAXINVENTONHAND,
                                          req.[PARTITION], req.DATAAREAID--,minkey.SAFETYFACTOR,maxkey.SAFETYFACTOR
                                 HAVING req.REQPOTYPE = MAX(req.REQPOTYPE) --(1:Purchase order, 1:Production, 2:Transfer, 3:Kanban)
             ) reqdim ON fi.[ITEMID] = reqdim.ITEMID AND ind.INVENTSIZEID = reqdim.INVENTSIZEID
             WHERE ISNULL(iis.STOPPED, 0) = 0
               AND eco.PRODUCTTYPE = 1
               AND cte.PARTITION = '5637144576'
               AND ecrpr.CATEGORYHIERARCHY = '5637144576'
               AND fi.DATAAREAID = 'hag'
               AND fi.AGRBLOCKED = 0)
SELECT c.[NO],
       c.[NAME],
       c.[DESCRIPTION],
       c.[PRIMARY_VENDOR_NO],
       c.[PURCHASE_LEAD_TIME_DAYS],
       c.[TRANSFER_LEAD_TIME_DAYS],
       c.[ORDER_FREQUENCY_DAYS],
       c.[ORDER_COVERAGE_DAYS],
       c.[MIN_ORDER_QTY],
       c.[ORIGINAL_NO],
       c.[CLOSED_FOR_ORDERING],
       c.[RESPONSIBLE],
       c.[SALE_PRICE],
       c.[COST_PRICE],
       c.[PURCHASE_PRICE],
       c.[ORDER_MULTIPLE],
       c.[QTY_PALLET],
       c.[VOLUME],
       c.[WEIGHT],
       c.[MIN_STOCK],
       c.[SAFETY_STOCK_UNITS],
       c.[MIN_DISPLAY_STOCK],
       c.[MAX_STOCK],
       c.[BASE_UNIT_OF_MEASURE],
       c.[PURCHASE_UNIT_OF_MEASURE],
       c.[QTY_PER_PURCHASE_UNIT],
       c.[SPECIAL_ORDER],
       c.[REORDER_POINT],
       c.[INCLUDE_IN_AGR],
       c.[CLOSED],
       c.[COMPANY],
       c.[SIZE_NO],
       c.[COLOUR_NO],
       c.[STYLE_NO],
       c.[No_TO_JOIN_IL],
       CAST(CASE
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN c.category
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN h1.parent_category
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN h2.parent_category
                WHEN h4.parent_category IS NULL THEN h3.parent_category
                ELSE h4.category END AS NVARCHAR(255)) AS ITEM_GROUP_NO_LVL_1,
       CAST(CASE
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN c.category
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN h1.parent_category
                WHEN h4.parent_category IS NULL THEN h2.parent_category
                ELSE h3.category END AS NVARCHAR(255)) AS ITEM_GROUP_NO_LVL_2,
       CAST(CASE
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN NULL
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN c.category
                WHEN h4.parent_category IS NULL THEN h1.parent_category
                ELSE h2.category END AS NVARCHAR(255)) AS ITEM_GROUP_NO_LVL_3,
       CAST(CASE
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL AND h1.parent_category IS NULL THEN NULL
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL AND h2.parent_category IS NULL THEN NULL
                WHEN h4.parent_category IS NULL AND h3.parent_category IS NULL THEN NULL
                WHEN h4.parent_category IS NULL THEN c.category
                ELSE h1.category END AS NVARCHAR(255)) AS ITEM_GROUP_NO_LVL_4
FROM item_data c
         LEFT JOIN ax_cus.v_item_group_hierarchy h1 ON c.category = h1.category
         LEFT JOIN ax_cus.v_item_group_hierarchy h2 ON h2.category = h1.parent_category
         LEFT JOIN ax_cus.v_item_group_hierarchy h3 ON h3.category = h2.parent_category
         LEFT JOIN ax_cus.v_item_group_hierarchy h4 ON h4.category = h3.parent_category

