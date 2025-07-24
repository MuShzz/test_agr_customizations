



CREATE VIEW [bc_rest_cus].[v_ITEM_LOCATION]
AS

SELECT DISTINCT
	  CAST(
        i.[No] +
        CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [ITEM_NO]
     , CAST(lms.locationNo AS NVARCHAR(255))															 AS LOCATION_NO     
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [SAFETY_STOCK_UNITS]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [MIN_DISPLAY_STOCK]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [MAX_STOCK]
     , CAST(NULL AS BIT)                                                                                 AS [CLOSED]
     , CAST(NULL AS BIT)                                                                                 AS [CLOSED_FOR_ORDERING]
     , CAST(NULL AS NVARCHAR(255))                                                                       AS [RESPONSIBLE]
     , CAST(NULL AS NVARCHAR(255))                                                                       AS [NAME]
     , CAST(NULL AS NVARCHAR(1000))                                                                      AS [DESCRIPTION]
     , CAST(NULL AS NVARCHAR(255))                                                                       AS [PRIMARY_VENDOR_NO]
     , CAST(NULL AS SMALLINT)                                                                            AS [PURCHASE_LEAD_TIME_DAYS]
     , CAST(NULL AS SMALLINT)                                                                            AS [TRANSFER_LEAD_TIME_DAYS]
     , CAST(NULL AS SMALLINT)                                                                            AS [ORDER_FREQUENCY_DAYS]
     , CAST(NULL AS SMALLINT)                                                                            AS [ORDER_COVERAGE_DAYS]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [MIN_ORDER_QTY]
     , CAST(NULL AS NVARCHAR(50))                                                                        AS [ORIGINAL_NO]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [SALE_PRICE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [COST_PRICE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [PURCHASE_PRICE]
     , CAST(i.OrderMultiple AS DECIMAL(18, 4))                                                           AS [ORDER_MULTIPLE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [QTY_PALLET]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [VOLUME]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [WEIGHT]
	 , CAST(0.0 AS DECIMAL(18, 4))																		 AS [REORDER_POINT]
     , CAST(IIF(s_sku.settingValue = 'true', 1, NULL) AS BIT)                                            AS [INCLUDE_IN_AGR]
	 , CAST(NULL AS BIT)																				 AS [SPECIAL_ORDER]
FROM
	bc_rest.item i
	LEFT JOIN bc_rest.item_variant iv ON iv.[ItemNo] = i.[No]
    INNER JOIN core.setting s_sku ON s_sku.settingKey = 'data_mapping_bc_sku_as_assortment'	
	LEFT JOIN bc_rest.stock_keeping_unit sku ON sku.ItemNo = i.[No]
	CROSS JOIN core.location_mapping_setup lms
WHERE
	--sku.[LocationCode] <> 'AKUREYRI' -- Added for SG1912-10
	lms.id = 1610
	OR lms.parentLocationId = 1610

UNION ALL

-- Added for SG1912-10
SELECT CAST(
        i.[No] +
        CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [ITEM_NO]
     , CAST(lms.locationNo AS NVARCHAR(255))                                                             AS [LOCATION_NO]     
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [SAFETY_STOCK_UNITS]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [MIN_DISPLAY_STOCK]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [MAX_STOCK]
     , CAST(NULL AS BIT)                                                                                 AS [CLOSED]
     , CAST(NULL AS BIT)                                                                                 AS [CLOSED_FOR_ORDERING]
     , CAST(NULL AS NVARCHAR(255))                                                                       AS [RESPONSIBLE]
     , CAST(NULL AS NVARCHAR(255))                                                                       AS [NAME]
     , CAST(NULL AS NVARCHAR(1000))                                                                      AS [DESCRIPTION]
     , CAST(NULL AS NVARCHAR(255))                                                                       AS [PRIMARY_VENDOR_NO]
     , CAST(NULL AS SMALLINT)                                                                            AS [PURCHASE_LEAD_TIME_DAYS]
     , CAST(NULL AS SMALLINT)                                                                            AS [TRANSFER_LEAD_TIME_DAYS]
     , CAST(NULL AS SMALLINT)                                                                            AS [ORDER_FREQUENCY_DAYS]
     , CAST(NULL AS SMALLINT)                                                                            AS [ORDER_COVERAGE_DAYS]
     , CAST(IIF(lms.locationNo='AKUREYRI',1,NULL) AS DECIMAL(18, 4))                                     AS [MIN_ORDER_QTY]
     , CAST(NULL AS NVARCHAR(50))                                                                        AS [ORIGINAL_NO]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [SALE_PRICE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [COST_PRICE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [PURCHASE_PRICE]
     , CAST(1 AS DECIMAL(18, 4))                                                                         AS [ORDER_MULTIPLE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [QTY_PALLET]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [VOLUME]
     , CAST(NULL AS DECIMAL(18, 4))                                                                      AS [WEIGHT]
	 , CAST(0.0 AS DECIMAL(18, 4))																		 AS [REORDER_POINT]
     , CAST(IIF(s_sku.settingValue = 'true', 1, NULL) AS BIT)                                            AS [INCLUDE_IN_AGR]
	 , CAST(NULL AS BIT)																				 AS [SPECIAL_ORDER]
FROM bc_rest.item i
	LEFT JOIN [bc_rest].item_variant iv ON iv.[ItemNo] = i.[No]
	INNER JOIN core.setting s_sku ON s_sku.settingKey = 'data_mapping_bc_sku_as_assortment'	
	CROSS JOIN core.location_mapping_setup lms
WHERE
	(CAST(i.[No] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) NOT IN (SELECT COMPONENT_ITEM_NO FROM bc_rest.v_BOM_COMPONENT)
	AND lms.id = 1619
	OR lms.parentLocationId = 1619
	AND CAST(i.[No] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) NOT IN (SELECT COMPONENT_ITEM_NO FROM bc_rest.v_BOM_COMPONENT))




