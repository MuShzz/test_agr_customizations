
CREATE VIEW [ax_cus].[v_ITEM_LOCATION]
AS
SELECT CAST(it.ITEMID AS NVARCHAR(255))                     AS [ITEM_NO],
       CAST(id.INVENTLOCATIONID AS NVARCHAR(255))           AS [LOCATION_NO],
       CAST(rit.MININVENTONHAND AS DECIMAL(18, 4))          AS [MIN_STOCK],

       CAST(rit.MININVENTONHAND AS DECIMAL(18, 4))          AS [SAFETY_STOCK_UNITS],
       CAST(NULL AS DECIMAL(18, 4))                         AS [MIN_DISPLAY_STOCK],

       CAST(rit.MAXINVENTONHAND AS DECIMAL(18, 4))          AS [MAX_STOCK],
       CAST(NULL AS BIT)                                    AS [CLOSED_FOR_ORDERING],
       CAST(it.ITEMBUYERGROUPID AS NVARCHAR(255))           AS [RESPONSIBLE],
       CAST(ISNULL(pt.NAME, it.NAMEALIAS) AS NVARCHAR(255)) AS [NAME],
       CAST(NULL AS NVARCHAR(1000))                         AS [DESCRIPTION],
       CASE
           WHEN NOT EXISTS (SELECT 1
                            FROM ax_cus.VENDTABLE v
                            WHERE v.ACCOUNTNUM = it.PRIMARYVENDORID) THEN 'vendor_missing'
           ELSE IIF(it.PRIMARYVENDORID = '',
                    'vendor_missing',
                    it.PRIMARYVENDORID)
           END                                              AS [PRIMARY_VENDOR_NO],
       CAST(ISNULL(ips.LEADTIME, 0) AS SMALLINT)            AS [PURCHASE_LEAD_TIME_DAYS],
       CAST(NULL AS SMALLINT)                               AS [TRANSFER_LEAD_TIME_DAYS],
       CAST(NULL AS SMALLINT)                               AS [ORDER_FREQUENCY_DAYS],
       CAST(NULL AS SMALLINT)                               AS [ORDER_COVERAGE_DAYS],
       CAST(NULL AS DECIMAL(18, 4))                         AS [MIN_ORDER_QTY],
       CAST(ISNULL(cv.EXTERNALITEMID, '') AS NVARCHAR(50))  AS [ORIGINAL_NO],
       CAST(itm.PRICE AS DECIMAL(18, 4))                    AS [SALE_PRICE],
       CAST(itm3.PRICE / (CASE
                              WHEN itm.PRICEUNIT = 0 THEN 1
                              ELSE itm.PRICEUNIT END)
           AS DECIMAL(18, 4))                               AS [COST_PRICE],
       CAST((itm2.PRICE / (CASE
                               WHEN itm2.PRICEUNIT = 0 THEN 1
                               ELSE itm2.PRICEUNIT END))
           AS DECIMAL(18, 4))                               AS [PURCHASE_PRICE],
       CAST(ISNULL(ips.MULTIPLEQTY, 1) AS DECIMAL(18, 4))   AS [ORDER_MULTIPLE],
       CAST(NULL AS DECIMAL(18, 4))                         AS [QTY_PALLET],
       CAST(it.UNITVOLUME AS DECIMAL(18, 4))                AS [VOLUME],
       CAST(it.NETWEIGHT AS DECIMAL(18, 4))                 AS [WEIGHT],
       CAST(0 AS DECIMAL(18, 4))                            AS [REORDER_POINT],
       CAST(1 AS BIT)                                       AS [INCLUDE_IN_AGR],
       CAST(ips.STOPPED AS BIT)                             AS [CLOSED],
       CAST(NULL AS BIT)                                    AS [SPECIAL_ORDER],
       CAST(it.DATAAREAID AS NVARCHAR(4))                   AS [COMPANY]

FROM [ax].INVENTTABLE it
         INNER JOIN [ax].ReqItemTable rit ON it.ITEMID = rit.ITEMID AND rit.DATAAREAID = it.DATAAREAID
         LEFT JOIN [ax].INVENTDIM id ON id.DATAAREAID = it.DATAAREAID AND id.PARTITION = it.PARTITION AND
                                        rit.COVINVENTDIMID = id.INVENTDIMID
         LEFT JOIN [ax].INVENTITEMPURCHSETUP ips
                   ON ips.ITEMID = it.ITEMID AND ips.PARTITION = it.PARTITION AND ips.DATAAREAID = it.DATAAREAID
         LEFT JOIN [ax].INVENTITEMINVENTSETUP iis
                   ON iis.ITEMID = it.ITEMID AND iis.PARTITION = it.PARTITION AND iis.DATAAREAID = it.DATAAREAID
         LEFT JOIN [ax].ECORESPRODUCTTRANSLATION pt ON it.PRODUCT = pt.PRODUCT AND pt.PARTITION = it.PARTITION AND
                                                       pt.LANGUAGEID = (SELECT TOP (1) language
                                                                        FROM ax.Companies cies
                                                                        WHERE cies.company = it.DATAAREAID)
         LEFT JOIN [ax].CUSTVENDEXTERNALITEM cv
                   ON it.ITEMID = cv.ITEMID AND it.PRIMARYVENDORID = cv.CUSTVENDRELATION AND
                      cv.DATAAREAID = it.DATAAREAID AND cv.PARTITION = it.PARTITION AND
                      cv.MODULETYPE = 3 -- Moduletype = 'ALL'
         LEFT JOIN [ax_cus].INVENTTABLEMODULE itm
                   ON it.ITEMID = itm.ITEMID AND itm.DATAAREAID = it.DATAAREAID AND itm.PARTITION = it.PARTITION AND
                      itm.MODULETYPE = 2 -- Moduletype = 'Sales'
         LEFT JOIN [ax_cus].INVENTTABLEMODULE itm2
                   ON it.ITEMID = itm2.ITEMID AND itm2.DATAAREAID = it.DATAAREAID AND itm2.PARTITION = it.PARTITION AND
                      itm2.MODULETYPE = 1 -- Moduletype = 'Purchases'
         LEFT JOIN [ax_cus].INVENTTABLEMODULE itm3
                   ON it.ITEMID = itm3.ITEMID AND itm3.DATAAREAID = it.DATAAREAID AND itm3.PARTITION = it.PARTITION AND
                      itm3.MODULETYPE = 0 -- Moduletype = 'INVENTORY'
WHERE ips.INVENTDIMID = 'Ax1'
  AND iis.INVENTDIMID = 'Ax1'
  AND ISNULL(iis.STOPPED, 0) = 0 -- Exclude items were "Stöðvið í birgðum" (Closed for stock move) active

