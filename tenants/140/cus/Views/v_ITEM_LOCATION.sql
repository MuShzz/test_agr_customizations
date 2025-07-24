
CREATE VIEW  [cus].[v_ITEM_LOCATION]
AS

    SELECT
        CAST(CONCAT(RTRIM(one.[ITEMNMBR]), ' - ', one.[Company]) AS NVARCHAR(255))    AS [ITEM_NO]
        ,CAST(RTRIM(one.[LOCNCODE]) AS NVARCHAR(255))   AS [LOCATION_NO]
        ,CAST(two.ORDRPNTQTY  AS DECIMAL(18,4))         AS [SAFETY_STOCK_UNITS]
        ,CAST(two.ORDRUPTOLVL  AS DECIMAL(18,4))        AS [MAX_STOCK]
        ,CAST(one.INACTIVE AS BIT)                      AS [CLOSED]
        ,CAST(NULL AS BIT)                              AS [CLOSED_FOR_ORDERING]
        ,CAST(NULL AS NVARCHAR(255))                    AS [RESPONSIBLE]
        ,CAST(RTRIM(one.[ITMSHNAM]) AS NVARCHAR(255))   AS [NAME]
        ,CAST(RTRIM(one.[ITEMDESC]) AS NVARCHAR(255))   AS [DESCRIPTION]
        ,CAST(IIF(RTRIM(TWO.[PRIMVNDR]) = '','vendor_missing',RTRIM(TWO.[PRIMVNDR])) AS NVARCHAR(255))   AS [PRIMARY_VENDOR_NO]
        ,CAST(CASE
                    WHEN two.REPLENISHMENTMETHOD = 1 THEN (two.MNFCTRNGFXDLDTM + two.MNFCTRNGVRBLLDTM)
                    WHEN two.REPLENISHMENTMETHOD = 2 THEN (two.PRCHSNGLDTM) END AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS]
        ,CAST(NULL AS SMALLINT)                         AS [TRANSFER_LEAD_TIME_DAYS]
        ,CAST(NULL AS SMALLINT)                         AS [ORDER_FREQUENCY_DAYS]
        ,CAST(NULL AS SMALLINT)                         AS [ORDER_COVERAGE_DAYS]
        ,CAST(two.MNMMORDRQTY AS DECIMAL(18,4))         AS [MIN_ORDER_QTY]
        ,CAST(three.VNDITNUM AS NVARCHAR(50))           AS [ORIGINAL_NO]
        ,CAST(IIF(five.CURNCYID='Z-US$',ISNULL(five.LISTPRCE,0),0) AS DECIMAL(18,4)) AS [SALE_PRICE]
        ,CAST(ISNULL(one.CURRCOST,0) AS DECIMAL(18,4))  AS [COST_PRICE]
        ,CAST(ISNULL(three.LRCPTCST,0) AS DECIMAL(18,4)) AS [PURCHASE_PRICE]
        ,CAST(two.ORDERMULTIPLE AS DECIMAL(18,4))       AS [ORDER_MULTIPLE]
        ,CAST(NULL AS DECIMAL(18,4))                    AS [QTY_PALLET]
        ,CAST(NULL AS DECIMAL(18,4))                    AS [VOLUME]
        ,CAST(convert(decimal(10,2), one.[ITEMSHWT])/100 AS DECIMAL(18,4))            AS [WEIGHT]
        ,CAST(two.ORDRPNTQTY  AS DECIMAL(18,4))         AS [REORDER_POINT]
        ,CAST(IIF(s_sku.settingValue = 'true',1,NULL)   AS BIT)    AS [INCLUDE_IN_AGR]
        ,CAST(NULL AS DECIMAL(18,4)) 				    AS [MIN_DISPLAY_STOCK]
		,CAST(NULL AS BIT)								AS [SPECIAL_ORDER]
        ,one.[Company]
	FROM
        [cus].[IV00101] one
        LEFT JOIN [cus].[IV00102] two ON one.ITEMNMBR = two.ITEMNMBR AND one.LOCNCODE = two.LOCNCODE AND one.Company = two.Company -- some items have multiple loc on two but t should be the loc in one
        LEFT JOIN [cus].[IV00103] three ON one.ITEMNMBR = three.ITEMNMBR AND two.PRIMVNDR = three.VENDORID AND one.Company = three.Company --some items dont have a primary vendor and multiple vendors on three
        LEFT JOIN [cus].[IV00105] five ON one.ITEMNMBR = five.ITEMNMBR AND five.CURRNIDX = (SELECT TOP 1 CURRNIDX FROM [cus].[IV00105] WHERE ITEMNMBR = one.ITEMNMBR AND LISTPRCE <> 0) AND one.Company = five.Company
        INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
	--WHERE one.ITEMNMBR='951004'


