

CREATE VIEW [cus].[v_ITEM] AS
	 SELECT
        CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [NO],
        CAST(i.[Description] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE ' - ' + iv.[Description] END AS NVARCHAR(255)) AS [NAME],
        CAST(i.[Description 2] AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(CASE WHEN ISNULL(v2.Blocked,'') <> '' THEN 'vendor_closed' WHEN i.[Vendor No_] = '' OR v2.[No_] IS NULL THEN 'vendor_missing' ELSE i.[Vendor No_] + '-' + i.Company END AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST(cus.LeadTimeConvert(i.[Lead Time Calculation],GETDATE()) AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(ISNULL((CASE WHEN ISNUMERIC(REPLACE([Order Frequency], CHAR(2), '')) = 1 THEN CAST(REPLACE([Order Frequency], '', '') AS INT) ELSE NULL END),0) AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS],
        CAST(i.[Minimum Order Quantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
        CAST(i.[Vendor Item No_] AS NVARCHAR(50)) AS [ORIGINAL_NO],
        CAST(0 AS BIT) AS CLOSED,
        CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(v2.[Purchaser Code] AS NVARCHAR(255)) AS [RESPONSIBLE],
        CAST(i.[Unit Price] AS DECIMAL(18,4)) AS [SALE_PRICE],
        CAST(i.[Unit Cost] AS DECIMAL(18,4)) AS [COST_PRICE],
        CAST(i.[Last Direct Cost] AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(i.[Order Multiple] AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET],
        CAST(i.[Unit Volume] AS DECIMAL(18,6)) AS [VOLUME],
        CAST(i.[Gross Weight] AS DECIMAL(18,6)) AS [WEIGHT],

        CAST(i.[Safety Stock Quantity] AS DECIMAL(18,4))	AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))							AS [MIN_DISPLAY_STOCK],

        CAST(i.[Maximum Inventory] AS DECIMAL(18,4)) AS [MAX_STOCK],
        CAST(i.[Item Category Code] AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(cus.ProductGroupCode(i.[Item Category Code], i.[Product Group Code],i.Company) AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST(uom_base.[Description] AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(uom_purch.[Description] AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(iuom.[Qty_ per Unit of Measure] AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(CASE WHEN i.[Reordering Policy] = 3 AND CAST('false' AS BIT) = 0 THEN 1 ELSE 0 END  AS BIT) AS [SPECIAL_ORDER],
        CAST(i.[Reorder Point] AS DECIMAL(18,4)) AS [REORDER_POINT],
		i.Company,
        CAST(0 AS BIT) AS [INCLUDE_IN_AGR]
    FROM
        cus.item i
        LEFT JOIN [cus].UnitofMeasure uom_base ON uom_base.Code = i.[Base Unit of Measure] AND i.Company = uom_base.Company
        LEFT JOIN [cus].UnitofMeasure uom_purch ON uom_purch.Code = i.[Purch_ Unit of Measure] AND i.Company = uom_purch.Company
        LEFT JOIN [cus].ItemUnitofMeasure iuom ON iuom.[Item No_] = i.[No_] AND iuom.[Code] = i.[Purch_ Unit of Measure] AND i.Company = iuom.Company
        --LEFT JOIN [cus].ItemUnitofMeasure iuom_pallet ON iuom_pallet.[Item No_] = i.[No_]  AND i.Company = iuom_pallet.Company            
        LEFT JOIN [cus].ItemVariant iv ON iv.[Item No_] = i.[No_] AND i.Company = iv.Company
        LEFT JOIN [cus].ItemVariant c ON c.Code = i.[Item Category Code] AND i.Company = c.Company
        LEFT JOIN [cus].vendor v2 ON i.[Vendor No_]= v2.[No_] AND i.Company = v2.Company
        INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
        --JOIN core.setting s on s.setting_key='disable_special_order_item_mapping'
	WHERE
		i.[Item Category Code] != 'VEHICLE'
		AND v2.[Purchaser Code] = 'AGR' 
		AND i.[Skip Req_ Worksheet] = 0
		AND i.Company = 'BLI'
		AND i.No_ NOT LIKE 'JAG%' 
		AND i.No_ NOT LIKE 'RO%' 
		AND i.No_ NOT LIKE 'HY%' 
		AND i.No_ NOT LIKE 'IV%'

	UNION ALL

	SELECT
        CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [NO],
        CAST(i.[Description] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE ' - ' + iv.[Description] END AS NVARCHAR(255)) AS [NAME],
        CAST(i.[Description 2] AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(CASE WHEN ISNULL(v2.Blocked,'') <> '' THEN 'vendor_closed' WHEN i.[Vendor No_] = '' OR v2.[No_] IS NULL THEN 'vendor_missing' ELSE i.[Vendor No_] + '-' + i.Company END AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST(cus.LeadTimeConvert(i.[Lead Time Calculation],GETDATE()) AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(ISNULL((CASE WHEN ISNUMERIC(REPLACE([Order Frequency], CHAR(2), '')) = 1 THEN CAST(REPLACE([Order Frequency], '', '') AS INT) ELSE NULL END),0) AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS],
        CAST(i.[Minimum Order Quantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
        CAST(i.[Vendor Item No_] AS NVARCHAR(50)) AS [ORIGINAL_NO],
        CAST(0 AS BIT) AS CLOSED,
        CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(v2.[Purchaser Code] AS NVARCHAR(255)) AS [RESPONSIBLE],
        CAST(i.[Unit Price] AS DECIMAL(18,4)) AS [SALE_PRICE],
        CAST(i.[Unit Cost] AS DECIMAL(18,4)) AS [COST_PRICE],
        CAST(i.[Last Direct Cost] AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(i.[Order Multiple] AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET],
        CAST(i.[Unit Volume] AS DECIMAL(18,6)) AS [VOLUME],
        CAST(i.[Gross Weight] AS DECIMAL(18,6)) AS [WEIGHT],

        CAST(i.[Safety Stock Quantity] AS DECIMAL(18,4))	AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))							AS [MIN_DISPLAY_STOCK],

        CAST(i.[Maximum Inventory] AS DECIMAL(18,4)) AS [MAX_STOCK],
        CAST(i.[Item Category Code] AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(cus.ProductGroupCode(i.[Item Category Code], i.[Product Group Code],i.Company) AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST(uom_base.[Description] AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(uom_purch.[Description] AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(iuom.[Qty_ per Unit of Measure] AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(CASE WHEN i.[Reordering Policy] = 3 AND CAST('false' AS BIT) = 0 THEN 1 ELSE 0 END  AS BIT) AS [SPECIAL_ORDER],
        CAST(i.[Reorder Point] AS DECIMAL(18,4)) AS [REORDER_POINT],
		i.Company,
        CAST(0 AS BIT) AS [INCLUDE_IN_AGR]
    FROM
        cus.item i
        LEFT JOIN [cus].UnitofMeasure uom_base ON uom_base.Code = i.[Base Unit of Measure] AND i.Company = uom_base.Company
        LEFT JOIN [cus].UnitofMeasure uom_purch ON uom_purch.Code = i.[Purch_ Unit of Measure] AND i.Company = uom_purch.Company
        LEFT JOIN [cus].ItemUnitofMeasure iuom ON iuom.[Item No_] = i.[No_] AND iuom.[Code] = i.[Purch_ Unit of Measure] AND i.Company = iuom.Company
        --LEFT JOIN [cus].ItemUnitofMeasure iuom_pallet ON iuom_pallet.[Item No_] = i.[No_]  AND i.Company = iuom_pallet.Company            
        LEFT JOIN [cus].ItemVariant iv ON iv.[Item No_] = i.[No_] AND i.Company = iv.Company
        LEFT JOIN [cus].ItemVariant c ON c.Code = i.[Item Category Code] AND i.Company = c.Company
        LEFT JOIN [cus].vendor v2 ON i.[Vendor No_]= v2.[No_] AND i.Company = v2.Company
        INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
        --JOIN core.setting s on s.setting_key='disable_special_order_item_mapping'
	WHERE
		i.[Item Category Code] != 'VEHICLE'
		AND v2.[Purchaser Code] = 'AGR' 
		AND i.[Skip Req_ Worksheet] = 0
		AND i.Company = 'JLR'
		AND (i.No_  LIKE 'JAG%' OR i.No_ LIKE 'RO%')

	UNION ALL

	SELECT
        CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [NO],
        CAST(i.[Description] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE ' - ' + iv.[Description] END AS NVARCHAR(255)) AS [NAME],
        CAST(i.[Description 2] AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(CASE WHEN ISNULL(v2.Blocked,'') <> '' THEN 'vendor_closed' WHEN i.[Vendor No_] = '' OR v2.[No_] IS NULL THEN 'vendor_missing' ELSE i.[Vendor No_] + '-' + i.Company END AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST(cus.LeadTimeConvert(i.[Lead Time Calculation],GETDATE()) AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(ISNULL((CASE WHEN ISNUMERIC(REPLACE([Order Frequency], CHAR(2), '')) = 1 THEN CAST(REPLACE([Order Frequency], '', '') AS INT) ELSE NULL END),0) AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS],
        CAST(i.[Minimum Order Quantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
        CAST(i.[Vendor Item No_] AS NVARCHAR(50)) AS [ORIGINAL_NO],
        CAST(0 AS BIT) AS CLOSED,
        CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(v2.[Purchaser Code] AS NVARCHAR(255)) AS [RESPONSIBLE],
        CAST(i.[Unit Price] AS DECIMAL(18,4)) AS [SALE_PRICE],
        CAST(i.[Unit Cost] AS DECIMAL(18,4)) AS [COST_PRICE],
        CAST(i.[Last Direct Cost] AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(i.[Order Multiple] AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET],
        CAST(i.[Unit Volume] AS DECIMAL(18,6)) AS [VOLUME],
        CAST(i.[Gross Weight] AS DECIMAL(18,6)) AS [WEIGHT],

        CAST(i.[Safety Stock Quantity] AS DECIMAL(18,4))	AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))							AS [MIN_DISPLAY_STOCK],

        CAST(i.[Maximum Inventory] AS DECIMAL(18,4)) AS [MAX_STOCK],
        CAST(i.[Item Category Code] AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(cus.ProductGroupCode(i.[Item Category Code], i.[Product Group Code],i.Company) AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST(uom_base.[Description] AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(uom_purch.[Description] AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(iuom.[Qty_ per Unit of Measure] AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(CASE WHEN i.[Reordering Policy] = 3 AND CAST('false' AS BIT) = 0 THEN 1 ELSE 0 END  AS BIT) AS [SPECIAL_ORDER],
        CAST(i.[Reorder Point] AS DECIMAL(18,4)) AS [REORDER_POINT],
		i.Company,
        CAST(0 AS BIT) AS [INCLUDE_IN_AGR]
	FROM
        cus.item i
        LEFT JOIN [cus].UnitofMeasure uom_base ON uom_base.Code = i.[Base Unit of Measure] AND i.Company = uom_base.Company
        LEFT JOIN [cus].UnitofMeasure uom_purch ON uom_purch.Code = i.[Purch_ Unit of Measure] AND i.Company = uom_purch.Company
        LEFT JOIN [cus].ItemUnitofMeasure iuom ON iuom.[Item No_] = i.[No_] AND iuom.[Code] = i.[Purch_ Unit of Measure] AND i.Company = iuom.Company
        --LEFT JOIN [cus].ItemUnitofMeasure iuom_pallet ON iuom_pallet.[Item No_] = i.[No_]  AND i.Company = iuom_pallet.Company            
        LEFT JOIN [cus].ItemVariant iv ON iv.[Item No_] = i.[No_] AND i.Company = iv.Company
        LEFT JOIN [cus].ItemVariant c ON c.Code = i.[Item Category Code] AND i.Company = c.Company
        LEFT JOIN [cus].vendor v2 ON i.[Vendor No_]= v2.[No_] AND i.Company = v2.Company
        INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
        --JOIN core.setting s on s.setting_key='disable_special_order_item_mapping'
	WHERE
		i.[Item Category Code] != 'VEHICLE'
		AND v2.[Purchaser Code] = 'AGR' 
		AND i.[Skip Req_ Worksheet] = 0
		AND i.Company = 'HYU'
		AND (i.No_ LIKE 'HY%' OR i.No_ LIKE 'IV%')


