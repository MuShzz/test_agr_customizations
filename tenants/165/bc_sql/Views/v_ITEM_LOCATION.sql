




CREATE VIEW [bc_sql_cus].[v_ITEM_LOCATION] AS

    SELECT DISTINCT
        --CAST(sku.[Item No_] + IIF(iv.[Code] IS NULL OR iv.[Code] = '', '', '-' + iv.[Code]) AS NVARCHAR(255)) AS [ITEM_NO]
		CAST(sku.[Item No_] AS NVARCHAR(255))												 AS [ITEM_NO] 
        ,CAST(sku.[Location Code] AS NVARCHAR(255))												AS [LOCATION_NO]
        ,CAST(0.0 AS DECIMAL(18,4)) AS [REORDER_POINT]
        ,CAST(sku.[Reorder Point] AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS]
        ,CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK]
        ,CAST(sku.[Maximum Inventory] AS DECIMAL(18,4)) AS [MAX_STOCK]
        --,CAST(NULL AS BIT) AS [CLOSED]
		,CAST(CASE WHEN it.[Blocked] = 1 THEN 1
				  WHEN ix.[ICE LAG Status Code$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] IN ('D','S','T') THEN 1
				  WHEN ix.[ICE LAG Order Type$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] = 'N'  THEN 1
				  WHEN it.[Vendor No_] IN ('86156611', '861566111', '89397749') AND it.[Purchasing Blocked] = 1 THEN 1
				  WHEN it.[Vendor No_] IN ('86156611', '861566111') AND ix.[Vendor Stock$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] = '' THEN 1
				  WHEN skux.[Product In Range$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] = 0 THEN 1
				  ELSE 0 END AS BIT) AS CLOSED
        ,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
        ,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
        ,CAST(NULL AS NVARCHAR(255)) AS [NAME]
        ,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
        ,CAST(NULLIF(sku.[Vendor No_],'') AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
        ,CAST(IIF(sku.[Replenishment System]=0,bc_sql.LeadTimeConvert(sku.[Lead Time Calculation]),NULL) AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS]
        ,CAST(IIF(sku.[Replenishment System]<>0,bc_sql.LeadTimeConvert(sku.[Lead Time Calculation]),NULL) AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS]
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
		,CAST(NULL AS BIT)	AS [SPECIAL_ORDER]
		, sku.[company]                                                                         AS [Company]
	FROM bc_sql.StockkeepingUnit sku
        INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.[Location Code]
        INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
		INNER JOIN bc_sql.Item it ON it.No_=sku.[Item No_]
		LEFT JOIN bc_sql_cus.ItemExt ix ON ix.No_=sku.[Item No_]
		LEFT JOIN bc_sql_cus.StockkeepingUnitExt skux ON skux.[Item No_] = sku.[Item No_] AND skux.[Location Code] = sku.[Location Code]
		LEFT JOIN [bc_sql].ItemVariant iv ON iv.[Item No_] = sku.[Item No_]
	--WHERE sku.[Item No_] LIKE '%G002129%'
    
	UNION ALL

		-- *** add all items for all virtual locations ***
		SELECT DISTINCT
			--CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [ITEM_NO]
			CAST(i.No_ AS NVARCHAR(255)) AS [ITEM_NO]
			,CAST(ml.locationNo AS NVARCHAR(255)) AS [LOCATION_NO]
			,CAST(0.0 AS DECIMAL(18,4)) AS [REORDER_POINT]
			,CAST(i.[Safety Stock Quantity] AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS]
			,CAST(i.[Reorder Point] AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK]
			,CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK]
			,CAST(NULL AS BIT) AS [CLOSED]
			,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
			,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
			,CAST(NULL AS NVARCHAR(255)) AS [NAME]
			,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
			,CAST(NULL AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
			,CAST(NULL AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS]
			,CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS]
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
			,CAST(NULL AS BIT)	AS [SPECIAL_ORDER]
			, i.[company]                                                                          AS [Company]
		 FROM
			core.location_mapping_setup ml
			INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
			CROSS JOIN bc_sql.Item i
			LEFT JOIN [bc_sql].ItemVariant iv ON iv.[Item No_] = i.[No_]
		WHERE
			ml.isVirtual = 1
	
	
	UNION

    SELECT
		--CAST(i.[No_] + IIF(iv.[Code] IS NULL OR iv.[Code] = '', '', '-' + iv.[Code]) AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(i.No_ AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(loc.[Code] AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(NULL AS DECIMAL(18, 4)) AS [REORDER_POINT],
		CAST(NULL AS DECIMAL(18, 4)) AS [SAFETY_STOCK_UNITS],
		CAST(NULL AS DECIMAL(18, 4)) AS [MIN_DISPLAY_STOCK],
		CAST(NULL AS DECIMAL(18, 4)) AS [MAX_STOCK],
		CAST(NULL AS BIT) AS [CLOSED],
		CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING],
		CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE],
		CAST(NULL AS NVARCHAR(255)) AS [NAME],
		CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION],
		CAST(NULL AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
		CAST(NULL AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
		CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
		CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
		CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS],
		CAST(NULL AS DECIMAL(18, 4)) AS [MIN_ORDER_QTY],
		CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO],
		CAST(NULL AS DECIMAL(18, 4)) AS [SALE_PRICE],
		CAST(NULL AS DECIMAL(18, 4)) AS [COST_PRICE],
		CAST(NULL AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
		CAST(NULL AS DECIMAL(18, 4)) AS [ORDER_MULTIPLE],
		CAST(NULL AS DECIMAL(18, 4)) AS [QTY_PALLET],
		CAST(NULL AS DECIMAL(18, 4)) AS [VOLUME],
		CAST(NULL AS DECIMAL(18, 4)) AS [WEIGHT],
		CAST(NULL AS BIT) AS [INCLUDE_IN_AGR],
		CAST(NULL AS BIT)	AS [SPECIAL_ORDER],
		i.[company] AS [Company]
	FROM
		bc_sql.Item i
		INNER JOIN bc_sql.Location loc ON i.company = loc.company
		LEFT JOIN bc_sql.ItemVariant iv ON iv.[Item No_] = i.[No_] AND i.[company] = iv.[company]
		INNER JOIN core.location_mapping_setup lm ON lm.locationNo = loc.[Code]
		INNER JOIN core.setting s_sku ON s_sku.settingKey = 'data_mapping_bc_sku_as_assortment'
	WHERE NOT EXISTS
	(
		SELECT 1 FROM bc_sql.StockkeepingUnit sku WHERE sku.[Item No_] = i.[No_]
	)
		  AND s_sku.settingValue = 'false';


