




-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Item location mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- 21.02.2024.DRG	The warehouse location (Location No = '01') should have all items available.
--					The cars (other locations) should only have assortment according to the SKU table. 
-- 03.03.2025.BF	added filtering of items with CC for item type
-- 3/3.DRG		    reorder point = 0 is treated as 1 in AGR. 
-- 11.03.2025.BF	Added secondary locations of 01 dynamically so this can be managed in UI with location setup
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_ITEM_LOCATION]
AS

-- Only include items in the car that exist in the SKU table. 
    SELECT CAST(sku.[ItemNo] + CASE WHEN sku.[VariantCode] = '' THEN '' ELSE '-' + sku.[VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO]
        ,CAST(sku.[LocationCode] AS NVARCHAR(255)) AS LOCATION_NO
		,CAST(CASE WHEN sku.[ReorderPoint] = 0 THEN 1 ELSE sku.[ReorderPoint] END AS DECIMAL(18,4)) AS [REORDER_POINT] -- 3/3.DRG reorder point = 0 is treated as 1 in AGR. 
        ,CAST(sku.[SafetyStockQuantity] AS DECIMAL(18,4)) AS SAFETY_STOCK_UNITS
        ,CAST(NULL AS DECIMAL(18,4)) AS MIN_DISPLAY_STOCK
        ,CAST(sku.[MaximumInventory] AS DECIMAL(18,4)) AS [MAX_STOCK]
        ,CAST(NULL AS BIT) AS [CLOSED]
        ,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
        ,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
        ,CAST(NULL AS NVARCHAR(255)) AS [NAME]
        ,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
        ,CAST(NULLIF(sku.[VendorNo],'') AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
        ,CAST(IIF(sku.[ReplenishmentSystem]='Purchase',bc_rest.LeadTimeConvert(sku.[LeadTimeCalculation],GETDATE()),NULL) AS SMALLINT) AS PURCHASE_LEAD_TIME_DAYS
        ,CAST(IIF(sku.[ReplenishmentSystem]<>'Purchase',bc_rest.LeadTimeConvert(sku.[LeadTimeCalculation],GETDATE()),NULL) AS SMALLINT) AS TRANSFER_LEAD_TIME_DAYS
        ,CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS]
        ,CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS]
        ,CAST(sku.[MinimumOrderQuantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY]
        ,CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO]
        ,CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE]
        ,CAST(sku.[UnitCost] AS DECIMAL(18,4)) AS [COST_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE]
        ,CAST(sku.[OrderMultiple] AS DECIMAL(18,4)) AS [ORDER_MULTIPLE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET]
        ,CAST(NULL AS DECIMAL(18,4)) AS [VOLUME]
        ,CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT]
		,CAST(IIF(s_sku.settingValue = 'true',1,NULL) AS BIT) AS [INCLUDE_IN_AGR]
		,CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
    FROM bc_rest.stock_keeping_unit sku
        INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.[LocationCode]
		INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
		WHERE
			(lm.LocationNo <> '01' 
		   OR lm.ParentLocationID NOT IN (SELECT ID FROM core.location_mapping_setup WHERE LocationNo = '01'))

UNION ALL 

-- warehouse location should have all items in the itemlist. 		
 SELECT DISTINCT
	   [NO] AS [PRODUCT_ITEM_NO]
		,CAST(lm.locationNo AS NVARCHAR(255)) AS LOCATION_NO -- Main warehouse
        ,CAST(NULL AS DECIMAL(18,4)) AS [REORDER_POINT]
        ,CAST(NULL AS DECIMAL(18,4)) AS SAFETY_STOCK_UNITS
        ,CAST(NULL AS DECIMAL(18,4)) AS MIN_DISPLAY_STOCK
        ,CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK]
        ,CAST(NULL AS BIT) AS [CLOSED]
        ,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
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
		,CAST(1 AS BIT) AS [INCLUDE_IN_AGR]
		,CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
FROM bc_rest.ITEM i
	cross JOIN core.location_mapping_setup lm
	INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
WHERE
	(lm.LocationNo = '01' 
       OR lm.ParentLocationID IN (SELECT ID FROM core.location_mapping_setup WHERE LocationNo = '01'));

	

