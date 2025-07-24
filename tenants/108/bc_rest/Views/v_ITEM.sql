

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Item mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- 27.01.2025.BF	Altered mapping of the closed items in AGR RVU-5
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_ITEM]
AS

    
	WITH qty_pallet_sub AS (
			 SELECT i.[No], iuom_pallet.[QtyperUnitofMeasure]
			   FROM [bc_rest].item i
		 INNER JOIN core.setting s_pallet ON s_pallet.settingKey = 'pallet_UOM_code_override'
		  LEFT JOIN [bc_rest].item_unit_of_measure iuom_pallet ON iuom_pallet.[ItemNo] = i.[No]  
			  WHERE iuom_pallet.[Code] = COALESCE(s_pallet.settingValue, (SELECT Code FROM bc_rest.unit_of_measure WHERE [InternationalStandardCode] = 'PF'))
			)
    SELECT
        CAST(i.[No] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255))		AS [NO],
        CAST(i.[Description] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' 
									THEN '' ELSE ' - ' + iv.[Description] END AS NVARCHAR(255))								AS [NAME],
        CAST(i.[Description2] AS NVARCHAR(1000)) 																			AS [DESCRIPTION],
        CAST(CASE WHEN ISNULL(v2.Blocked,'') <> '' 
				  THEN 'vendor_closed' WHEN i.[VendorNo] = '' OR v2.[No] IS NULL 
				  THEN 'vendor_missing' ELSE i.[VendorNo] END AS NVARCHAR(255))												AS PRIMARY_VENDOR_NO,
        bc_rest.LeadTimeConvert(i.[LeadTimeCalculation],GETDATE()) 															AS PURCHASE_LEAD_TIME_DAYS,
		CAST(NULL AS SMALLINT) 																								AS [TRANSFER_LEAD_TIME_DAYS],
	    CAST(NULL AS SMALLINT) 																								AS ORDER_FREQUENCY_DAYS,
		CAST(NULL AS SMALLINT) 																								AS ORDER_COVERAGE_DAYS,
        CAST(i.[MinimumOrderQuantity] AS DECIMAL(18,4)) 																	AS MIN_ORDER_QTY,
        CAST(i.[VendorItemNo] AS NVARCHAR(255)) 																			AS ORIGINAL_NO,
        --CAST(i.[Blocked] AS BIT) 																							AS CLOSED,
		CAST(CASE 
			WHEN varer.Item_Group_Code IN ('C','S') THEN 1
			ELSE i.[Blocked] 
			END 
			AS BIT) 																										AS CLOSED,
        CAST(i.[PurchasingBlocked] AS BIT) 																					AS CLOSED_FOR_ORDERING,
        CAST(v2.[PurchaserCode] AS NVARCHAR(255)) 																			AS RESPONSIBLE,
        CAST(i.[UnitPrice] AS DECIMAL(18,4)) 																				AS SALE_PRICE,
        CAST(i.[UnitCost] AS DECIMAL(18,4)) 																				AS COST_PRICE,
        CAST(i.[LastDirectCost] AS DECIMAL(18,4)) 																			AS PURCHASE_PRICE,
        CAST(i.[OrderMultiple] AS DECIMAL(18,4)) 																			AS ORDER_MULTIPLE,
		CAST(iuom_pallet.[QtyperUnitofMeasure] AS DECIMAL(18,4)) 															AS QTY_PALLET,
        CAST(i.[UnitVolume] AS DECIMAL(18,6)) 																				AS VOLUME,
        CAST(i.[GrossWeight] AS DECIMAL(18,6)) 																				AS [WEIGHT],
        CAST(i.[MaximumInventory] AS DECIMAL(18,4)) 																		AS MAX_STOCK,
        CAST(CASE WHEN c.[ParentCategory] <> '' THEN c.[ParentCategory] ELSE i.[ItemCategoryCode] END AS NVARCHAR(255))		AS ITEM_GROUP_NO_LVL_1,
        CAST(CASE WHEN c.[ParentCategory] <> '' THEN i.[ItemCategoryCode] ELSE '' END AS NVARCHAR(255))						AS ITEM_GROUP_NO_LVL_2,
		CAST(NULL AS NVARCHAR(255)) 																						AS ITEM_GROUP_NO_LVL_3,
        CAST(uom_base.[Description] AS NVARCHAR(50)) 																		AS BASE_UNIT_OF_MEASURE,
        CAST(uom_purch.[Description] AS NVARCHAR(50)) 																		AS PURCHASE_UNIT_OF_MEASURE,
		CAST(ISNULL(NULLIF(iuom.[QtyperUnitofMeasure], 0), 1) AS DECIMAL(18,4))												AS [QTY_PER_PURCHASE_UNIT],
        CAST(i.[ReorderPoint] AS DECIMAL(18,4)) 																			AS REORDER_POINT,
		CAST(CASE WHEN i.[ReorderingPolicy] = 'Order' AND CAST(s.settingValue AS BIT) = 0 THEN 1 ELSE 0 END AS BIT)			AS SPECIAL_ORDER,
		CAST(IIF(s_sku.settingValue = 'true',NULL,1) AS BIT)																AS [INCLUDE_IN_AGR],
		CAST(i.[SafetyStockQuantity] AS DECIMAL(18,4))																		AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))																							AS [MIN_DISPLAY_STOCK]
    FROM
        [bc_rest].item i
        LEFT JOIN [bc_rest].unit_of_measure uom_base	ON uom_base.Code = i.[BaseUnitofMeasure]
        LEFT JOIN [bc_rest].unit_of_measure uom_purch	ON uom_purch.Code = i.[PurchUnitofMeasure]
        LEFT JOIN [bc_rest].item_unit_of_measure iuom	ON iuom.[ItemNo] = i.[No] AND iuom.[Code] = i.[PurchUnitofMeasure]
        LEFT JOIN qty_pallet_sub iuom_pallet			ON iuom_pallet.[No] = i.[No]
        LEFT JOIN [bc_rest].item_variant iv				ON iv.[ItemNo] = i.[No]
        LEFT JOIN [bc_rest].item_category c				ON c.Code = i.[ItemCategoryCode]
        LEFT JOIN [bc_rest].vendor v2					ON i.[VendorNo]= v2.[No]
        INNER JOIN core.setting s						ON s.settingKey='disable_special_order_item_mapping'
		INNER JOIN core.setting s_repl					ON s_repl.settingKey='data_mapping_bc_item_replenishment'
		INNER JOIN core.setting s_sku					ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
		LEFT JOIN bc_rest_cus.varer varer				ON varer.No = i.No
    WHERE
        i.[Type]  = 'Inventory' -- Inventory items only
        AND
        (CASE i.[ReplenishmentSystem]  
			 WHEN 'Purchase' THEN 0
			 WHEN 'Prod. Order' THEN 1 
			 WHEN 'Transfer' THEN 2
			 WHEN 'Assembly' THEN 3
        END) IN (SELECT value FROM STRING_SPLIT(s_repl.settingValue,';'))
		--AND i.No='0000SE0104F'


