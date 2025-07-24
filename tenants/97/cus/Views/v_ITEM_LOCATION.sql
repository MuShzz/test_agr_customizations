


-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM_LOCATION] AS
	SELECT
		CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [ITEM_NO],
		'01-BLI' AS [LOCATION_NO],
        CAST(0 AS DECIMAL(18,4))		AS [REORDER_POINT],

        CAST(NULL AS DECIMAL(18,4))		AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))		AS [MIN_DISPLAY_STOCK],

        CAST(NULL AS DECIMAL(18,4))		AS [MAX_STOCK],
        CAST(NULL AS BIT)				AS [CLOSED],
        CAST(NULL AS BIT)				AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255))		AS [RESPONSIBLE],
        CAST(NULL AS NVARCHAR(255))		AS [NAME],
        CAST(NULL AS NVARCHAR(1000))	AS [DESCRIPTION],
        CAST(NULL AS NVARCHAR(255))		AS [PRIMARY_VENDOR_NO],
        CAST(NULL AS SMALLINT)			AS PURCHASE_LEAD_TIME_DAYS,
        CAST(NULL AS SMALLINT)			AS TRANSFER_LEAD_TIME_DAYS,
        CAST(NULL AS SMALLINT)			AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT)			AS [ORDER_COVERAGE_DAYS],
        CAST(NULL AS DECIMAL(18,4))		AS [MIN_ORDER_QTY],
        CAST(NULL AS NVARCHAR(50))		AS [ORIGINAL_NO],
        CAST(NULL AS DECIMAL(18,4))		AS [SALE_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [COST_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [PURCHASE_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4))		AS [QTY_PALLET],
        CAST(NULL AS DECIMAL(18,4))		AS [VOLUME],
        CAST(NULL AS DECIMAL(18,4))		AS [WEIGHT],
        CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(NULL AS BIT)   AS [SPECIAL_ORDER],
		i.Company
	FROM cus.Item i
		LEFT JOIN [cus].vendor v2 ON i.[Vendor No_]= v2.[No_] AND i.Company = v2.Company
        LEFT JOIN [cus].ItemVariant iv ON iv.[Item No_] = i.[No_] AND i.Company = iv.Company
	   INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
	WHERE i.Company = 'BLI'
		AND i.[Item Category Code] != 'VEHICLE'
		AND v2.[Purchaser Code] = 'AGR' 
		AND i.[Skip Req_ Worksheet] = 0
		AND (i.No_ NOT LIKE 'JAG%' OR i.No_ NOT LIKE 'RO%')
		AND (i.No_ NOT LIKE 'HY%' OR i.No_ NOT LIKE 'IV%')


	UNION ALL

	SELECT
		CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [ITEM_NO],
		'01-JLR'						AS [LOCATION_NO],
        CAST(0 AS DECIMAL(18,4))		AS [REORDER_POINT],

        CAST(NULL AS DECIMAL(18,4))		AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))		AS [MIN_DISPLAY_STOCK],

        CAST(NULL AS DECIMAL(18,4))		AS [MAX_STOCK],
        CAST(NULL AS BIT)				AS [CLOSED],
        CAST(NULL AS BIT)				AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255))		AS [RESPONSIBLE],
        CAST(NULL AS NVARCHAR(255))		AS [NAME],
        CAST(NULL AS NVARCHAR(1000))	AS [DESCRIPTION],
        CAST(NULL AS NVARCHAR(255))		AS [PRIMARY_VENDOR_NO],
        CAST(NULL AS SMALLINT)			AS PURCHASE_LEAD_TIME_DAYS,
        CAST(NULL AS SMALLINT)			AS TRANSFER_LEAD_TIME_DAYS,
        CAST(NULL AS SMALLINT)			AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT)			AS [ORDER_COVERAGE_DAYS],
        CAST(NULL AS DECIMAL(18,4))		AS [MIN_ORDER_QTY],
        CAST(NULL AS NVARCHAR(50))		AS [ORIGINAL_NO],
        CAST(NULL AS DECIMAL(18,4))		AS [SALE_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [COST_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [PURCHASE_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4))		AS [QTY_PALLET],
        CAST(NULL AS DECIMAL(18,4))		AS [VOLUME],
        CAST(NULL AS DECIMAL(18,4))		AS [WEIGHT],
        CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(NULL AS BIT)   AS [SPECIAL_ORDER],
		i.Company
	FROM cus.Item i
		LEFT JOIN [cus].vendor v2 ON i.[Vendor No_]= v2.[No_] AND i.Company = v2.Company
        LEFT JOIN [cus].ItemVariant iv ON iv.[Item No_] = i.[No_] AND i.Company = iv.Company
	   INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
	WHERE i.Company = 'JLR'
		AND i.[Item Category Code] != 'VEHICLE'
		AND v2.[Purchaser Code] = 'AGR'
		AND (i.No_ LIKE 'JAG%' OR i.No_ LIKE 'RO%') 
		AND i.[Skip Req_ Worksheet] = 0

	UNION ALL

	SELECT
		CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [ITEM_NO],
		'08-HYU' AS [LOCATION_NO],
        CAST(0 AS DECIMAL(18,4))		AS [REORDER_POINT],

        CAST(NULL AS DECIMAL(18,4))		AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))		AS [MIN_DISPLAY_STOCK],

        CAST(NULL AS DECIMAL(18,4))		AS [MAX_STOCK],
        CAST(NULL AS BIT)				AS [CLOSED],
        CAST(NULL AS BIT)				AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255))		AS [RESPONSIBLE],
        CAST(NULL AS NVARCHAR(255))		AS [NAME],
        CAST(NULL AS NVARCHAR(1000))	AS [DESCRIPTION],
        CAST(NULL AS NVARCHAR(255))		AS [PRIMARY_VENDOR_NO],
        CAST(NULL AS SMALLINT)			AS PURCHASE_LEAD_TIME_DAYS,
        CAST(NULL AS SMALLINT)			AS TRANSFER_LEAD_TIME_DAYS,
        CAST(NULL AS SMALLINT)			AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT)			AS [ORDER_COVERAGE_DAYS],
        CAST(NULL AS DECIMAL(18,4))		AS [MIN_ORDER_QTY],
        CAST(NULL AS NVARCHAR(50))		AS [ORIGINAL_NO],
        CAST(NULL AS DECIMAL(18,4))		AS [SALE_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [COST_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [PURCHASE_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4))		AS [QTY_PALLET],
        CAST(NULL AS DECIMAL(18,4))		AS [VOLUME],
        CAST(NULL AS DECIMAL(18,4))		AS [WEIGHT],
        CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(NULL AS BIT)   AS [SPECIAL_ORDER],
		i.Company
	FROM cus.Item i
		LEFT JOIN [cus].vendor v2 ON i.[Vendor No_]= v2.[No_] AND i.Company = v2.Company
        LEFT JOIN [cus].ItemVariant iv ON iv.[Item No_] = i.[No_] AND i.Company = iv.Company
	   INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
	WHERE i.Company = 'HYU'
		AND i.[Item Category Code] != 'VEHICLE'
		AND v2.[Purchaser Code] = 'AGR'
		AND v2.No_ != 'V-IVF'
		AND i.[Skip Req_ Worksheet] = 0
		AND (i.No_ LIKE 'HY%' OR i.No_ LIKE 'IV%') 


	UNION ALL

	SELECT
		CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [ITEM_NO],
		'12-HYU' AS [LOCATION_NO],
        CAST(0 AS DECIMAL(18,4))		AS [REORDER_POINT],

        CAST(NULL AS DECIMAL(18,4))		AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))		AS [MIN_DISPLAY_STOCK],

        CAST(NULL AS DECIMAL(18,4))		AS [MAX_STOCK],
        CAST(NULL AS BIT)				AS [CLOSED],
        CAST(NULL AS BIT)				AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255))		AS [RESPONSIBLE],
        CAST(NULL AS NVARCHAR(255))		AS [NAME],
        CAST(NULL AS NVARCHAR(1000))	AS [DESCRIPTION],
        CAST(NULL AS NVARCHAR(255))		AS [PRIMARY_VENDOR_NO],
        CAST(NULL AS SMALLINT)			AS PURCHASE_LEAD_TIME_DAYS,
        CAST(NULL AS SMALLINT)			AS TRANSFER_LEAD_TIME_DAYS,
        CAST(NULL AS SMALLINT)			AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT)			AS [ORDER_COVERAGE_DAYS],
        CAST(NULL AS DECIMAL(18,4))		AS [MIN_ORDER_QTY],
        CAST(NULL AS NVARCHAR(50))		AS [ORIGINAL_NO],
        CAST(NULL AS DECIMAL(18,4))		AS [SALE_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [COST_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [PURCHASE_PRICE],
        CAST(NULL AS DECIMAL(18,4))		AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4))		AS [QTY_PALLET],
        CAST(NULL AS DECIMAL(18,4))		AS [VOLUME],
        CAST(NULL AS DECIMAL(18,4))		AS [WEIGHT],
        CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(NULL AS BIT)   AS [SPECIAL_ORDER],
		i.Company
	FROM cus.Item i
		LEFT JOIN [cus].vendor v2 ON i.[Vendor No_]= v2.[No_] AND i.Company = v2.Company
        LEFT JOIN [cus].ItemVariant iv ON iv.[Item No_] = i.[No_] AND i.Company = iv.Company
	   INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
	WHERE i.Company = 'HYU'
		AND i.[Item Category Code] != 'VEHICLE'
		AND v2.[Purchaser Code] = 'AGR'
		AND v2.No_ = 'V-IVF'
		AND i.[Skip Req_ Worksheet] = 0
		AND (i.No_ LIKE 'HY%' OR i.No_ LIKE 'IV%') 


