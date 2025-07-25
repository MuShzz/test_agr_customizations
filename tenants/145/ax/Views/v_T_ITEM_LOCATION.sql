CREATE VIEW [ax_cus].[v_T_ITEM_LOCATION] AS

SELECT DISTINCT
    CAST(pinf.NO AS NVARCHAR(255))					AS [ITEM_NO],
    CAST(id.INVENTLOCATIONID AS NVARCHAR(255))		AS [LOCATION_NO],

    CAST(rit.MININVENTONHAND AS DECIMAL(18, 4))		AS [SAFETY_STOCK_UNITS],
    CAST(NULL AS DECIMAL(18, 4))					AS [MIN_DISPLAY_STOCK],

    CAST(rit.MAXINVENTONHAND AS DECIMAL(18, 4))		AS [MAX_STOCK],
    CAST(NULL AS BIT)								AS [CLOSED_FOR_ORDERING],
    CAST(it.ITEMBUYERGROUPID AS NVARCHAR(255))		AS [RESPONSIBLE],
    CAST(erpt_prod.NAME AS NVARCHAR(255))			AS [NAME],
    CAST(erpt_prod.DESCRIPTION AS NVARCHAR(1000))	AS [DESCRIPTION],
    CAST(pinf.PRIMARY_VENDOR_NO AS NVARCHAR(255))	AS [PRIMARY_VENDOR_NO],
    CAST(NULL AS SMALLINT)							AS [PURCHASE_LEAD_TIME_DAYS],
    CAST(NULL AS SMALLINT)							AS [TRANSFER_LEAD_TIME_DAYS],
    CAST(NULL AS SMALLINT)							AS [ORDER_FREQUENCY_DAYS],
    CAST(NULL AS SMALLINT)							AS [ORDER_COVERAGE_DAYS],
    CAST(NULL AS DECIMAL(18, 4))					AS [MIN_ORDER_QTY],
    CAST(pinf.ORIGINAL_NO AS NVARCHAR(50))			AS [ORIGINAL_NO],
    CAST(NULL AS DECIMAL(18, 4))					AS [SALE_PRICE],
    CAST(NULL AS DECIMAL(18, 4))					AS [COST_PRICE],
    CAST(NULL AS DECIMAL(18, 4))					AS [PURCHASE_PRICE],
    CAST(NULL AS DECIMAL(18, 4))					AS [ORDER_MULTIPLE],
    CAST(NULL AS DECIMAL(18, 4))					AS [QTY_PALLET],
    CAST(it.UNITVOLUME AS DECIMAL(18, 4))			AS [VOLUME],
    CAST(it.NETWEIGHT AS DECIMAL(18, 4))			AS [WEIGHT],
    CAST(0 AS DECIMAL(18, 4))						AS [REORDER_POINT],
    CAST(1 AS BIT)									AS [INCLUDE_IN_AGR],
    CAST(NULL AS BIT)								AS [CLOSED],
    CAST(NULL AS BIT)								AS [SPECIAL_ORDER],
    CAST(it.DATAAREAID AS NVARCHAR(4))				AS [COMPANY]
FROM
    ax_cus.RETAILGROUPMEMBERLINE mline
        INNER JOIN ax_cus.INVENTTABLE it ON it.DATAAREAID = 'hag' and it.PRODUCT = mline.PRODUCT
        INNER JOIN ax_cus.RETAILASSORTMENTPRODUCTLINE ralp ON ralp.LINETYPE=1 and ralp.RETAILGROUPMEMBERLINEID = mline.RECID
        INNER JOIN ax_cus.RETAILASSORTMENTTABLE rat ON rat.RECID = ralp.ASSORTMENTRECID
        INNER JOIN ax_cus.REQITEMTABLE rit ON it.ITEMID = rit.ITEMID
        INNER JOIN ax_cus.INVENTDIM id
                   ON id.INVENTLOCATIONID = rat.ASSORTMENTID AND id.INVENTDIMID = rit.COVINVENTDIMID
        INNER JOIN ax_cus.Item_v pinf ON pinf.No_TO_JOIN_IL = it.ITEMID AND pinf.COLOUR_NO = id.INVENTCOLORID
        AND pinf.SIZE_NO = id.INVENTSIZEID AND pinf.STYLE_NO = id.INVENTSTYLEID
        INNER JOIN core.location_mapping_setup lms ON lms.locationNo = id.INVENTLOCATIONID
        LEFT JOIN ax.ECORESPRODUCTTRANSLATION erpt_prod ON erpt_prod.PRODUCT = it.PRODUCT AND erpt_prod.PARTITION = it.PARTITION AND erpt_prod.LANGUAGEID = 'is'
