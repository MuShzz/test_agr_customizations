CREATE VIEW [ax_cus].[v_ITEM] AS

	   SELECT DISTINCT
        CAST(fi.ITEMID AS NVARCHAR(255))                                                                                                                    AS [NO],
        CAST(COALESCE(TRIM(erpt.NAME), TRIM(fi.NAMEALIAS)) AS NVARCHAR(255))                                                                                AS [NAME],
        CAST(erpt.DESCRIPTION AS NVARCHAR(1000))                                                                                           AS [DESCRIPTION],
		CASE 
			WHEN NOT EXISTS (SELECT 1 FROM [ax_cus].VENDTABLE v WHERE v.ACCOUNTNUM = fi.PRIMARYVENDORID) THEN CAST('vendor_missing' AS NVARCHAR(255))
			ELSE IIF(fi.PRIMARYVENDORID='', CAST('vendor_missing' AS NVARCHAR(255)),CAST( fi.PRIMARYVENDORID AS NVARCHAR(255))) 
		                                                                                                                                                END AS [PRIMARY_VENDOR_NO],
        CAST(ISNULL(ips.LEADTIME,0) AS SMALLINT)                                                                                                            AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)                                                                                                                              AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT )                                                                                                                             AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT )                                                                                                                             AS [ORDER_COVERAGE_DAYS],
        CAST(ips.[LOWESTQTY] AS DECIMAL(18,4))                                                                                                              AS [MIN_ORDER_QTY],
        CAST(ISNULL(cv.EXTERNALITEMID, '') AS NVARCHAR(50))                                                                                                 AS [ORIGINAL_NO],
        CAST(0 AS BIT)                                                                                                                                      AS [CLOSED_FOR_ORDERING],
        CAST(fi.ITEMBUYERGROUPID AS NVARCHAR(255))                                                                                                          AS [RESPONSIBLE],
        CAST(itm.PRICE AS DECIMAL(18,4))                                                                                                                    AS [SALE_PRICE],
        --CAST(itm.PRICE AS DECIMAL(18,4)) / (CASE WHEN CAST(itm.PRICEUNIT AS DECIMAL(18,4)) = 0 THEN 1 ELSE CAST(itm.PRICEUNIT AS DECIMAL(18,4)) END)        AS [COST_PRICE],
        CAST(itm.PRICE AS DECIMAL(18,4))                                                                                                                    AS [COST_PRICE],
        CAST(itm2.PRICE AS DECIMAL(18,4)) / (CASE WHEN CAST(itm2.PRICEUNIT AS DECIMAL(18,4)) = 0 THEN 1 ELSE CAST(itm2.PRICEUNIT AS DECIMAL(18,4)) END)     AS [PURCHASE_PRICE],
        CASE WHEN ISNULL(CAST(ips.MULTIPLEQTY AS DECIMAL(18,4)),0) < 1 THEN 1 ELSE ISNULL(CAST(ips.MULTIPLEQTY AS DECIMAL(18,4)),0)                     END AS [ORDER_MULTIPLE],
        CAST(iex.STANDARDPALLETQUANTITY AS DECIMAL(18,4))                                                                                                   AS [QTY_PALLET],
        CAST(fi.UNITVOLUME AS DECIMAL(18,6))                                                                                                                AS [VOLUME],
        CAST((fi.NETWEIGHT+iex.TARAWEIGHT) AS DECIMAL(18,6))                                                                                                AS [WEIGHT],
        CAST(0 AS DECIMAL(18,4))                                                                                                                            AS [MIN_STOCK],

        CAST(0 AS DECIMAL(18,4))                                                                                                                            AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))                                                                                                                         AS [MIN_DISPLAY_STOCK],

        CAST(NULL AS DECIMAL(18,4))                                                                                                                         AS [MAX_STOCK],
        CAST(ivg.ITEMGROUPID AS NVARCHAR(255))                                                                                                              AS [ITEM_GROUP_NO_LVL_1],
        CAST(itm.SUPPITEMGROUPID AS NVARCHAR(255))                                                                                                          AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255))                                                                                                                         AS [ITEM_GROUP_NO_LVL_3],
        CAST(NULL AS NVARCHAR(50))                                                                                                                          AS [BASE_UNIT_OF_MEASURE],
        CAST(NULL AS NVARCHAR(50))                                                                                                                          AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(1 AS DECIMAL(18,4))                                                                                                                            AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS BIT)                                                                                                                                      AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4))                                                                                                                            AS [REORDER_POINT],
		CAST(1 AS BIT)                                                                                                                                      AS [INCLUDE_IN_AGR],
		CAST(ips.STOPPED AS BIT)                                                                                                                            AS [CLOSED],
        CAST(fi.DATAAREAID AS NVARCHAR(4))                                                                                                                  AS [COMPANY]
    FROM ax.INVENTTABLE fi
INNER JOIN [ax].ECORESPRODUCT erp ON fi.PRODUCT = erp.RECID AND fi.PARTITION = erp.PARTITION
LEFT JOIN [ax].ECORESPRODUCTTRANSLATION erpt ON erp.RECID = erpt.PRODUCT AND erp.PARTITION = erpt.PARTITION AND erpt.LANGUAGEID = 'da'-- (SELECT top(1) language FROM ax.Companies cies where cies.company = fi.DATAAREAID)
LEFT JOIN [ax_cus].VENDTABLE v ON fi.PRIMARYVENDORID = v.ACCOUNTNUM AND v.DATAAREAID = fi.DATAAREAID AND v.PARTITION = fi.PARTITION
LEFT JOIN [ax].INVENTITEMPURCHSETUP ips ON fi.ITEMID = ips.ITEMID AND ips.DATAAREAID = fi.DATAAREAID AND ips.PARTITION = fi.PARTITION
LEFT JOIN [ax].CUSTVENDEXTERNALITEM cv ON fi.ITEMID = cv.ITEMID AND fi.PRIMARYVENDORID = cv.CUSTVENDRELATION AND cv.DATAAREAID = fi.DATAAREAID AND cv.PARTITION = fi.PARTITION AND cv.MODULETYPE = 3 -- Moduletype = 'ALL'
LEFT JOIN [ax_cus].INVENTTABLEMODULE itm ON fi.ITEMID = itm.ITEMID AND itm.DATAAREAID = fi.DATAAREAID AND itm.PARTITION = fi.PARTITION AND itm.MODULETYPE = 2 -- Moduletype = 'Sales'
LEFT JOIN [ax_cus].INVENTTABLEMODULE itm2 ON fi.ITEMID = itm2.ITEMID AND itm2.DATAAREAID = fi.DATAAREAID AND itm2.PARTITION = fi.PARTITION AND itm2.MODULETYPE = 1 -- Moduletype = 'Purchases'
LEFT JOIN [ax].INVENTITEMINVENTSETUP iis ON fi.ITEMID = iis.ITEMID AND iis.DATAAREAID = fi.DATAAREAID AND iis.PARTITION = fi.PARTITION
LEFT JOIN [ax].INVENTITEMGROUPITEM ivg ON ivg.ITEMID = fi.ITEMID AND ivg.ITEMDATAAREAID = fi.DATAAREAID AND ivg.PARTITION = fi.PARTITION
left join ax_cus.INVENTTABLE_extra iex on iex.ITEMID=fi.ITEMID and iex.PARTITION=fi.PARTITION and iex.DATAAREAID=fi.DATAAREAID
WHERE ips.INVENTDIMID = 'Ax1' AND ISNULL(iis.STOPPED, 0) = 0
