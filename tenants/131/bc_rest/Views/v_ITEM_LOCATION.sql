
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Item location mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- 19.03.2025.BF	Created cus version to alter mapping of closed also client doesnt use stockkeepingunits table
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_ITEM_LOCATION]
AS

    SELECT 
		CAST(i.[No] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [ITEM_NO]
        ,CAST(lm.locationNo AS NVARCHAR(255)) AS LOCATION_NO
        ,CAST(i.ReorderPoint AS DECIMAL(18,4)) AS [REORDER_POINT]
        ,CAST(NULL AS DECIMAL(18,4)) AS SAFETY_STOCK_UNITS
        ,CAST(NULL AS DECIMAL(18,4)) AS MIN_DISPLAY_STOCK
        ,CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK]
        ,CAST(IIF(i.Blocked=1,1,0)  AS BIT) AS [CLOSED]
        ,CAST(IIF(i.PurchasingBlocked=1 AND lm.locationNo='00',1,0)  AS BIT) AS [CLOSED_FOR_ORDERING]
        ,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
        ,CAST(NULL AS NVARCHAR(255)) AS [NAME]
        ,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
        ,CAST(NULL AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
        ,CAST(NULL AS SMALLINT) AS PURCHASE_LEAD_TIME_DAYS
        ,CAST(NULL AS SMALLINT) AS TRANSFER_LEAD_TIME_DAYS
        ,CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS]
        ,CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS]
        ,CAST(NULL AS DECIMAL(18,4)) AS [MIN_ORDER_QTY]
        ,CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO]
        ,CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [ORDER_MULTIPLE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET]
        ,CAST(NULL AS DECIMAL(18,4)) AS [VOLUME]
        ,CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT]
		,CAST(IIF(s_sku.settingValue = 'true',1,NULL) AS BIT) AS [INCLUDE_IN_AGR]
		,CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
    FROM bc_rest.item i
		LEFT JOIN [bc_rest].item_variant iv				ON iv.[ItemNo] = i.[No]
        cross JOIN core.location_mapping_setup lm
		INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
		--WHERE i.No='YUYTZ12S'



