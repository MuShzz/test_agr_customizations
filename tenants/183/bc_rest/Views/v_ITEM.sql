


-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Item mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created

-- 03.06.2025.DRG Adding all style+color as items to use for customer planning. 
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
--      CAST(i.[Description] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' 
--									THEN '' ELSE ' - ' + iv.[Description] END AS NVARCHAR(255))								AS [NAME],
		CAST(i.[Description] + CASE WHEN i.[Description2] IS NULL OR i.[Description2] = '' 
									THEN '' ELSE ' - ' + i.[Description2] END AS NVARCHAR(255))								AS [NAME],									
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
        CAST(i.[Blocked] AS BIT) 																							AS CLOSED,
        CAST(i.[PurchasingBlocked] AS BIT) 																					AS CLOSED_FOR_ORDERING,
        CAST(v2.[PurchaserCode] AS NVARCHAR(255)) 																			AS RESPONSIBLE,
        CAST(i.[UnitPrice] AS DECIMAL(18,4)) 																				AS SALE_PRICE,
        CAST(i.[UnitCost] AS DECIMAL(18,4)) 																				AS COST_PRICE,
        CAST(i.[LastDirectCost] AS DECIMAL(18,4)) 																			AS PURCHASE_PRICE,
        CAST(i.[OrderMultiple] AS DECIMAL(18,4)) 																			AS ORDER_MULTIPLE,
		CAST(iuom_pallet.[QtyperUnitofMeasure] AS DECIMAL(18,4)) 															AS QTY_PALLET,
        CAST(i.[UnitVolume] AS DECIMAL(18,6)) 																				AS VOLUME,
        CAST(i.[GrossWeight] AS DECIMAL(18,6)) 																				AS [WEIGHT],
        CAST(i.[SafetyStockQuantity] AS DECIMAL(18,4)) 																		AS SAFETY_STOCK_UNITS,
        CAST(NULL AS DECIMAL(18,4)) 																		                AS MIN_DISPLAY_STOCK,
        CAST(i.[MaximumInventory] AS DECIMAL(18,4)) 																		AS MAX_STOCK,
        CAST(CASE WHEN c.[ParentCategory] <> '' THEN c.[ParentCategory] ELSE i.[ItemCategoryCode] END AS NVARCHAR(255))		AS ITEM_GROUP_NO_LVL_1,
        CAST(CASE WHEN c.[ParentCategory] <> '' THEN i.[ItemCategoryCode] ELSE '' END AS NVARCHAR(255))						AS ITEM_GROUP_NO_LVL_2,
		CAST(NULL AS NVARCHAR(255)) 																						AS ITEM_GROUP_NO_LVL_3,
        CAST(uom_base.[Description] AS NVARCHAR(50)) 																		AS BASE_UNIT_OF_MEASURE,
        CAST(uom_purch.[Description] AS NVARCHAR(50)) 																		AS PURCHASE_UNIT_OF_MEASURE,
        CAST(iuom.[QtyperUnitofMeasure] AS DECIMAL(18,4)) 																	AS QTY_PER_PURCHASE_UNIT,
        CAST(i.[ReorderPoint] AS DECIMAL(18,4)) 																			AS REORDER_POINT,
		CAST(CASE WHEN i.[ReorderingPolicy] = 'Order' AND CAST(s.settingValue AS BIT) = 0 THEN 1 ELSE 0 END AS BIT)			AS SPECIAL_ORDER,
		CAST(IIF(s_sku.settingValue = 'true',NULL,1) AS BIT)																AS [INCLUDE_IN_AGR]
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
		INNER JOIN bc_rest_cus.item_extra_info iei		ON iei.No = i.No
    WHERE
        i.[Type]  = 'Inventory' -- Inventory items only
        AND
        (CASE i.[ReplenishmentSystem]  
			 WHEN 'Purchase' THEN 0
			 WHEN 'Prod. Order' THEN 1 
			 WHEN 'Transfer' THEN 2
			 WHEN 'Assembly' THEN 3
        END) IN (SELECT value FROM STRING_SPLIT(s_repl.settingValue,';'))
		AND LEN(i.No) > 8 --  Only include final products 
		AND iei.Inventory_Posting_Group = 'FINISHED'

UNION ALL

-- 03.06.2025.DRG Adding all style+color as items to use for customer planning. 
-- 03.06.2025.DRG using avg purch. price and avg. cost price to begin with. 

    SELECT
        CAST(CONCAT(iei.[bc1_ItemHeaderID],iei.bc1_ItemVariant1ID) AS NVARCHAR(255))										AS [NO],
		CAST(CONCAT(i.[Description], 
			CASE WHEN iei.bc1_ItemVariant1Name IS NULL THEN '' ELSE ' - ' + iei.bc1_ItemVariant1Name END) AS NVARCHAR(255)) AS [NAME],
									
        CAST(NULL AS NVARCHAR(1000)) 																			AS [DESCRIPTION],
        CAST(CASE WHEN ISNULL(v2.Blocked,'') <> '' 
				  THEN 'vendor_closed' WHEN i.[VendorNo] = '' OR v2.[No] IS NULL 
				  THEN 'vendor_missing' ELSE i.[VendorNo] END AS NVARCHAR(255))												AS PRIMARY_VENDOR_NO,
        CAST(0 AS SMALLINT) 																								AS PURCHASE_LEAD_TIME_DAYS,
		CAST(NULL AS SMALLINT) 																								AS [TRANSFER_LEAD_TIME_DAYS],
	    CAST(NULL AS SMALLINT) 																								AS ORDER_FREQUENCY_DAYS,
		CAST(NULL AS SMALLINT) 																								AS ORDER_COVERAGE_DAYS,
        CAST(i.[MinimumOrderQuantity] AS DECIMAL(18,4)) 																	AS MIN_ORDER_QTY,
        CAST(NULL AS NVARCHAR(255)) 																						AS ORIGINAL_NO,
        CAST(MIN(CAST(i.blocked AS INT)) AS BIT)																			AS CLOSED,
        CAST(i.[PurchasingBlocked] AS BIT) 																					AS CLOSED_FOR_ORDERING,
        CAST(v2.[PurchaserCode] AS NVARCHAR(255)) 																			AS RESPONSIBLE,
        CAST(i.[UnitPrice] AS DECIMAL(18,4)) 																				AS SALE_PRICE,
        CAST(MAX(i.[UnitCost]) AS DECIMAL(18,4)) 																			AS COST_PRICE,
        CAST(MAX(i.[LastDirectCost]) AS DECIMAL(18,4)) 																		AS PURCHASE_PRICE,
        CAST(i.[OrderMultiple] AS DECIMAL(18,4)) 																			AS ORDER_MULTIPLE,
		CAST(iuom_pallet.[QtyperUnitofMeasure] AS DECIMAL(18,4)) 															AS QTY_PALLET,
        CAST(i.[UnitVolume] AS DECIMAL(18,6)) 																				AS VOLUME,
        CAST(i.[GrossWeight] AS DECIMAL(18,6)) 																				AS [WEIGHT],
        CAST(i.[SafetyStockQuantity] AS DECIMAL(18,4)) 																		AS SAFETY_STOCK_UNITS,
        CAST(NULL AS DECIMAL(18,4)) 																		                AS MIN_DISPLAY_STOCK,
        CAST(i.[MaximumInventory] AS DECIMAL(18,4)) 																		AS MAX_STOCK,
        CAST(CASE WHEN c.[ParentCategory] <> '' THEN c.[ParentCategory] ELSE i.[ItemCategoryCode] END AS NVARCHAR(255))		AS ITEM_GROUP_NO_LVL_1,
        CAST(CASE WHEN c.[ParentCategory] <> '' THEN i.[ItemCategoryCode] ELSE '' END AS NVARCHAR(255))						AS ITEM_GROUP_NO_LVL_2,
		CAST(NULL AS NVARCHAR(255)) 																						AS ITEM_GROUP_NO_LVL_3,
        CAST(uom_base.[Description] AS NVARCHAR(50)) 																		AS BASE_UNIT_OF_MEASURE,
        CAST(uom_purch.[Description] AS NVARCHAR(50)) 																		AS PURCHASE_UNIT_OF_MEASURE,
        CAST(iuom.[QtyperUnitofMeasure] AS DECIMAL(18,4)) 																	AS QTY_PER_PURCHASE_UNIT,
        CAST(i.[ReorderPoint] AS DECIMAL(18,4)) 																			AS REORDER_POINT,
		CAST(CASE WHEN i.[ReorderingPolicy] = 'Order' AND CAST(s.settingValue AS BIT) = 0 THEN 1 ELSE 0 END AS BIT)			AS SPECIAL_ORDER,
		CAST(IIF(s_sku.settingValue = 'true',NULL,1) AS BIT)																AS [INCLUDE_IN_AGR]
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
		INNER JOIN bc_rest_cus.item_extra_info iei		ON iei.[No] = i.[No]
    WHERE
        i.[Type]  = 'Inventory' -- Inventory items only
        AND
        (CASE i.[ReplenishmentSystem]  
			 WHEN 'Purchase' THEN 0
			 WHEN 'Prod. Order' THEN 1 
			 WHEN 'Transfer' THEN 2
			 WHEN 'Assembly' THEN 3
        END) IN (SELECT value FROM STRING_SPLIT(s_repl.settingValue,';'))
		AND LEN(i.No) > 8 --  Only include final products 
		AND iei.Inventory_Posting_Group = 'FINISHED'
		AND CAST(CONCAT(iei.[bc1_ItemHeaderID],iei.bc1_ItemVariant1ID) AS NVARCHAR(255)) -- 03.06.2025.drg TEMPORARY FILTER
		NOT IN
(
N'',
N'G11309990',
N'G12689408',
N'G12719991',
N'G12739993',
N'G13749403',
N'G13749408',
N'G13749410',
N'G13749992',
N'G13749993',
N'G13749995',
N'G13749998',
N'G21259990',
N'G21749991',
N'G21769998',
N'G21799998',
N'G22619984',
N'G22629988',
N'G22639411',
N'G22639416',
N'G22669416',
N'G72999403',
N'G76859405',
N'G78949409',
N'G87139998',
N'G89189405',
N'S11779984',
N'S11779988'
)


		GROUP BY iei.[bc1_ItemHeaderID], i.[Description],iei.bc1_ItemVariant1Name,v2.Blocked 
				,i.[VendorNo],v2.[No]
				--,i.[LeadTimeCalculation]
				,i.[MinimumOrderQuantity] 
                 --,i.[VendorItemNo]
                 ,i.[PurchasingBlocked] 
                 ,v2.[PurchaserCode] 
                 ,i.[UnitPrice] 
                 ,i.[OrderMultiple] 
                 ,iuom_pallet.[QtyperUnitofMeasure]
                 ,i.[UnitVolume]
                 ,i.[GrossWeight]
                 ,i.[SafetyStockQuantity]
                 ,i.[MaximumInventory] 
				 ,c.[ParentCategory]
                 ,i.[ItemCategoryCode]
                 ,uom_base.[Description] 
                 ,uom_purch.[Description] 
                 ,iuom.[QtyperUnitofMeasure] 
                 ,i.[ReorderPoint] 
				 ,iei.bc1_ItemVariant1ID
				 ,i.ReorderingPolicy
				 ,s_sku.settingValue
                 ,s.settingValue



