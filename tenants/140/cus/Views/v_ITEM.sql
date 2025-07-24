CREATE VIEW [cus].[v_ITEM]
AS

            SELECT
                CAST(CONCAT(RTRIM(one.[ITEMNMBR]), ' - ', one.[Company]) AS NVARCHAR(255))                                  AS [NO],
                CAST(RTRIM(one.[ITMSHNAM]) AS NVARCHAR(255))                                                                AS [NAME],
                CAST(RTRIM(one.[ITEMDESC]) AS NVARCHAR(1000))                                                               AS [DESCRIPTION],
                CAST(CASE WHEN ISNULL(PM.HOLD,0) <> 0 THEN 'vendor_closed' WHEN two.[PRIMVNDR] IS NULL OR two.[PRIMVNDR] = '' THEN 'vendor_missing'
                WHEN two.[PRIMVNDR] IS NOT NULL OR two.[PRIMVNDR] <> '' THEN RTRIM(two.[PRIMVNDR]) END AS NVARCHAR(255))    AS [PRIMARY_VENDOR_NO],
                CAST(CASE
                    WHEN two.REPLENISHMENTMETHOD = 1 THEN (two.MNFCTRNGFXDLDTM + two.MNFCTRNGVRBLLDTM)
                    WHEN two.REPLENISHMENTMETHOD = 2 THEN (two.PRCHSNGLDTM)
                    END AS SMALLINT)                                                                                        AS [PURCHASE_LEAD_TIME_DAYS],
                CAST(NULL AS SMALLINT)                                                                                      AS [TRANSFER_LEAD_TIME_DAYS],
                CAST(NULL AS SMALLINT)                                                                                      AS [ORDER_FREQUENCY_DAYS],
                CAST(NULL AS SMALLINT)                                                                                      AS [ORDER_COVERAGE_DAYS],
                CAST(two.MNMMORDRQTY AS DECIMAL(18,4))                                                                      AS [MIN_ORDER_QTY],
                CAST(RTRIM(three.[VNDITNUM]) AS NVARCHAR(50))                                                               AS [ORIGINAL_NO],
                CAST(one.[INACTIVE] AS BIT)                                                                                 AS [CLOSED],
                CAST(0 AS BIT)                                                                                              AS [CLOSED_FOR_ORDERING],
                CAST(two.BUYERID AS NVARCHAR(255))                                                                          AS [RESPONSIBLE],
                CAST(ISNULL(five.LISTPRCE,0) AS DECIMAL(18,4))                                                              AS [SALE_PRICE],
                CAST(ISNULL(one.CURRCOST,0) AS DECIMAL(18,4))                                                               AS [COST_PRICE],
                CAST(ISNULL(three.LRCPTCST,0) AS DECIMAL(18,4))                                                             AS [PURCHASE_PRICE],
                CAST(two.ORDERMULTIPLE AS DECIMAL(18,4))                                                                    AS [ORDER_MULTIPLE],
                CAST(NULL AS DECIMAL(18,4))                                                                                 AS [QTY_PALLET],
                CAST(NULL AS DECIMAL(18,4))                                                                                 AS [VOLUME],
                CAST(convert(decimal(10,2), one.[ITEMSHWT])/100 AS DECIMAL(18,4))                                           AS [WEIGHT],
                CAST(two.ORDRUPTOLVL AS DECIMAL(18,4))                                                                      AS [MAX_STOCK],
                CAST(two.ORDRPNTQTY AS DECIMAL(18,4)) 																		AS [SAFETY_STOCK_UNITS],
                CAST(NULL AS DECIMAL(18,4)) 																		        AS [MIN_DISPLAY_STOCK],
                CAST(one.USCATVLS_5 AS NVARCHAR(255))                                                                       AS [ITEM_GROUP_NO_LVL_1],
                CAST(NULL AS NVARCHAR(255))                                                                                 AS [ITEM_GROUP_NO_LVL_2],
                CAST(NULL AS NVARCHAR(255))                                                                                 AS [ITEM_GROUP_NO_LVL_3],
                CAST(RTRIM(one.[PRCHSUOM]) AS NVARCHAR(50))                                                                 AS [BASE_UNIT_OF_MEASURE],
                CAST(RTRIM(one.[PRCHSUOM]) AS NVARCHAR(50))                                                                 AS [PURCHASE_UNIT_OF_MEASURE],
                CAST(six.QTYBSUOM AS DECIMAL(18,4))                                                                         AS [QTY_PER_PURCHASE_UNIT],
                CAST(CASE WHEN two.[ORDERPOLICY] = 3 AND CAST(s.settingValue as BIT) = 0 THEN 1 ELSE 0 END AS BIT)          AS [SPECIAL_ORDER],
                CAST(ISNULL(two.[ORDRPNTQTY],0) AS DECIMAL(18,4))                                                           AS [REORDER_POINT],
                CAST(IIF(s_sku.settingValue = 'true',NULL,1) as BIT)                                                        AS [INCLUDE_IN_AGR],
                one.[Company]

            FROM
                [cus].[IV00101] one
                LEFT JOIN [cus].[IV00102] two ON one.ITEMNMBR = two.ITEMNMBR and one.LOCNCODE = two.LOCNCODE AND one.Company = two.Company -- some items have multiple loc on two but t should be the loc in one
                LEFT JOIN [cus].[IV00103] three ON one.ITEMNMBR = three.ITEMNMBR and two.PRIMVNDR = three.VENDORID AND one.Company = three.Company --some items dont have a primary vendor and multiple vendors on three
                LEFT JOIN [cus].[IV00105] five ON one.ITEMNMBR = five.ITEMNMBR and five.CURRNIDX = (SELECT TOP 1 CURRNIDX FROM [cus].[IV00105] WHERE ITEMNMBR = one.ITEMNMBR AND LISTPRCE <> 0) AND one.Company = five.Company
                LEFT JOIN [cus].[IV00106] six ON one.ITEMNMBR = six.ITEMNMBR and one.PRCHSUOM = six.UOFM AND one.Company = six.Company
                LEFT JOIN [cus].[PM00200] PM ON three.VENDORID = PM.VENDORID and one.Company = PM.Company
                INNER JOIN core.setting s on s.settingKey='disable_special_order_item_mapping'
                INNER JOIN core.setting s_repl ON s_repl.settingKey='data_mapping_bc_item_replenishment'
                INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'

