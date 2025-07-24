CREATE VIEW [cus].v_ITEM
AS
WITH item_prices as (select mi.itemId,
                            i.*,
                            ROW_NUMBER() OVER (PARTITION BY mi.itemId ORDER BY CASE WHEN i.SVALUES IS NULL THEN 1 ELSE 0 END, i.SVALUES) AS rnk
                     from cus.MIITEM mi
                              CROSS APPLY STRING_SPLIT(mi.sales, '|') AS s -- break the list into rows
                              INNER JOIN cus.ICITEM AS i
                                         ON i.ITEMNO = s.value)
SELECT DISTINCT CAST(mi.itemId AS nvarchar(255))             AS [NO],
                CAST(mi.descr AS nvarchar(255))              AS [NAME],
                CAST(mi.xdesc AS nvarchar(1000))             AS [DESCRIPTION],
                CAST(mi.suplId AS nvarchar(255))             AS [PRIMARY_VENDOR_NO],
                CAST(ISNULL(isup.lead, mi.lead) AS smallint) AS [PURCHASE_LEAD_TIME_DAYS],
                CAST(NULL AS smallint)                       AS [TRANSFER_LEAD_TIME_DAYS],
                CAST(NULL AS smallint)                       AS [ORDER_FREQUENCY_DAYS],
                CAST(NULL AS smallint)                       AS [ORDER_COVERAGE_DAYS],
                CAST(mi.minLvl AS decimal(18, 4))            AS [MIN_ORDER_QTY],
                CAST(mi.ref AS nvarchar(50))                 AS [ORIGINAL_NO],
                CAST(mi.status AS bit)                       AS [CLOSED],
                CAST(mi.status AS bit)                       AS [CLOSED_FOR_ORDERING],
                CAST(mi.ordQty AS nvarchar(255))             AS [RESPONSIBLE],
                CAST(i.SVALUES AS decimal(18, 4))            AS [SALE_PRICE],
                CAST(NULL AS decimal(18, 4))                 AS [COST_PRICE],
                CAST(i.[VALUES] AS decimal(18, 4))           AS [PURCHASE_PRICE],
                CAST(NULL AS decimal(18, 4))                 AS [ORDER_MULTIPLE],
                CAST(NULL AS decimal(18, 4))                 AS [QTY_PALLET],
                CAST(NULL AS decimal(18, 4))                 AS [VOLUME],
                CAST(i.UNITWGT AS decimal(18, 4))            AS [WEIGHT],
                CAST(NULL AS decimal(18, 4))                 AS [SAFETY_STOCK_UNITS],
                CAST(NULL AS decimal(18, 4))                 AS [MIN_DISPLAY_STOCK],
                CAST(NULL AS decimal(18, 4))                 AS [MAX_STOCK],
                CAST(NULL AS nvarchar(255))                  AS [ITEM_GROUP_NO_LVL_1],
                CAST(NULL AS nvarchar(255))                  AS [ITEM_GROUP_NO_LVL_2],
                CAST(NULL AS nvarchar(255))                  AS [ITEM_GROUP_NO_LVL_3],
                CAST(i.STOCKUNIT AS nvarchar(50))            AS [BASE_UNIT_OF_MEASURE],
                CAST(i.STOCKUNIT AS nvarchar(50))            AS [PURCHASE_UNIT_OF_MEASURE],
                CAST(NULL AS decimal(18, 4))                 AS [QTY_PER_PURCHASE_UNIT],
                CAST(1 AS decimal(18, 4))                    AS [REORDER_POINT],
                CAST(0 AS bit)                               AS [SPECIAL_ORDER],
                CAST(1 AS bit)                               AS [INCLUDE_IN_AGR]
from cus.MIITEM mi
         LEFT JOIN cus.MIQSUP isup
                   on mi.itemId = isup.itemId
                       and mi.suplId = isup.suplId
         LEFT JOIN item_prices AS i
                   ON i.itemId = mi.itemId
