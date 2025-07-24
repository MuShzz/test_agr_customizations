CREATE VIEW [cus].[v_ITEM] 
AS

	   SELECT
        CAST(i.[No] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [NO],
        CAST(i.[Description] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE ' - ' + iv.[Description] END AS NVARCHAR(255)) AS [NAME],
        CAST(i.[Description2] AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(CASE WHEN ISNULL(v2.Blocked,'') <> '' THEN 'vendor_closed' WHEN i.[VendorNo] = '' OR v2.[No] IS NULL THEN 'vendor_missing' ELSE i.[VendorNo] END AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST([bc_rest].[LeadTimeConvert](i.[LeadTimeCalculation],GETDATE()) AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)								AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT )								AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT ) 							AS [ORDER_COVERAGE_DAYS],
        CAST(i.[MinimumOrderQuantity] AS DECIMAL(18,4))		AS [MIN_ORDER_QTY],
        CAST(i.[VendorItemNo] AS NVARCHAR(50))				AS [ORIGINAL_NO],
		CAST(i.[Blocked] AS BIT) 							AS CLOSED,
        CAST(i.[PurchasingBlocked] AS BIT) 					AS [CLOSED_FOR_ORDERING],
        CAST(cci.Planner_ID_GRBAS AS NVARCHAR(255))			AS [RESPONSIBLE],
        CAST(i.[UnitPrice] AS DECIMAL(18,4)) 				AS [SALE_PRICE],
        CAST(i.[UnitCost] AS DECIMAL(18,4)) 				AS [COST_PRICE],
        CAST(i.[LastDirectCost] AS DECIMAL(18,4))			AS [PURCHASE_PRICE],
        CAST(i.[OrderMultiple] AS DECIMAL(18,4))			AS [ORDER_MULTIPLE],
        CAST(iuom_pallet.[QtyperUnitofMeasure]				AS DECIMAL(18,4)) AS [QTY_PALLET],
        CAST(i.[UnitVolume] AS DECIMAL(18,6))				AS [VOLUME],
        CAST(i.[GrossWeight] AS DECIMAL(18,6))				AS [WEIGHT],

        CAST(i.[SafetyStockQuantity] AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],

        CAST(i.[MaximumInventory] AS DECIMAL(18,4))			AS [MAX_STOCK],
        CAST(CASE WHEN c.[ParentCategory] <> '' THEN c.[ParentCategory] ELSE i.[ItemCategoryCode] END AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(CASE WHEN c.[ParentCategory] <> '' THEN i.[ItemCategoryCode] ELSE '' END AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST(uom_base.[Description] AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(uom_purch.[Description] AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(iuom.[QtyperUnitofMeasure] AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(CASE WHEN i.[ReorderingPolicy] = 'Order' AND CAST('false' AS BIT) = 0 THEN 1 ELSE 0 END AS BIT) AS [SPECIAL_ORDER],
        CAST(ISNULL(i.[ReorderPoint],0) AS DECIMAL(18,4)) AS [REORDER_POINT],
        CAST(0 AS BIT) AS [INCLUDE_IN_AGR],
		i.Company
    FROM
        [cus].item i
		LEFT JOIN cus.CustomColumns_Item cci ON cci.No = i.No AND cci.company = i.Company
        LEFT JOIN [cus].unit_of_measure uom_base			ON uom_base.Code = i.[BaseUnitofMeasure] AND i.Company = uom_base.Company
        LEFT JOIN [cus].unit_of_measure uom_purch			ON uom_purch.Code = i.[PurchUnitofMeasure] AND i.Company = uom_purch.Company
        LEFT JOIN [cus].item_unit_of_measure iuom			ON iuom.[ItemNo] = i.[No] AND iuom.[Code] = i.[PurchUnitofMeasure] AND i.Company = iuom.Company
        LEFT JOIN [cus].item_unit_of_measure iuom_pallet	ON iuom_pallet.[ItemNo] = i.[No]  AND i.Company = iuom_pallet.Company
			AND iuom_pallet.[Code] = COALESCE(NULL, (SELECT Code FROM [cus].unit_of_measure WHERE [InternationalStandardCode] = CASE WHEN iuom_pallet.Company = 'GNT' THEN 'PE'
																																	 WHEN iuom_pallet.Company = 'GST' THEN 'PL'
																																 END
																							   AND [Code] =  'PALL'))
        LEFT JOIN [cus].item_variant iv ON iv.[ItemNo] = i.[No] AND i.Company = iv.Company
        LEFT JOIN [cus].item_category c ON c.Code = i.[ItemCategoryCode] AND i.Company = c.Company
        LEFT JOIN [cus].vendor v2		ON i.[VendorNo]= v2.[No] AND i.Company = v2.Company
		WHERE i.Blocked = 0
        --JOIN core.setting s on s.setting_key='disable_special_order_item_mapping'

