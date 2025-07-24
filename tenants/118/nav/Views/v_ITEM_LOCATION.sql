



-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Item location mapping from nav to adi format
--
-- 09.10.2024.TO    Created
-- 10.01.2025.BF	altered mapping to be balet ot have transfer order multiple in items coming from location 01 - WUR-8
-- ===============================================================================
CREATE VIEW [nav_cus].[v_ITEM_LOCATION]
AS

	WITH LocationCodes AS (
		SELECT DISTINCT locationNo AS [Location Code]
		FROM dbo.AGREssentials_items
		WHERE locationNo != '01'
	),
	sku_aux AS (
	  SELECT 
		   '01' AS [Location Code]
		  ,i.No_ AS [Item No_]
		  ,CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE iv.Code END AS [Variant Code]
		  ,i.[Unit Cost]
		  ,i.[Replenishment System]
		  ,'' AS [Transfer-from Code]
		  ,i.[Lead Time Calculation]
		  ,i.[Minimum Order Quantity]
		  ,i.[Safety Stock Quantity]
		  ,i.[Order Multiple]
		  ,i.[Reorder Point]
		  ,i.[Maximum Inventory]
		  ,i.[Vendor No_]
	  FROM dbo.Item i
	  LEFT JOIN dbo.ItemVariant iv ON i.No_ = iv.[Item No_]

	  UNION ALL
  
	  SELECT 
			l.[Location Code],
			i.No_ AS [Item No_],
			CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE iv.Code END AS [Variant Code],
			i.[Unit Cost],
			i.[Replenishment System],
			'' AS [Transfer-from Code],
			i.[Lead Time Calculation],
			i.[Minimum Order Quantity],
			i.[Safety Stock Quantity],
			i.[Order Multiple],
			i.[Reorder Point],
			i.[Maximum Inventory],
			i.[Vendor No_]
		FROM dbo.Item i
		LEFT JOIN dbo.ItemVariant iv ON i.No_ = iv.[Item No_]
		CROSS JOIN LocationCodes l)

	SELECT CAST([Item No_] + CASE WHEN [Variant Code] = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO]
		,CAST([Location Code] AS NVARCHAR(255)) AS LOCATION_NO
		,CAST([Reorder Point] AS DECIMAL(18,4)) AS [REORDER_POINT]
		,CAST([Maximum Inventory] AS DECIMAL(18,4)) AS [MAX_STOCK]
		,CAST(NULL AS BIT) AS [CLOSED]
		,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
		,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
		,CAST(NULL AS NVARCHAR(255)) AS [NAME]
		,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
		,CAST(NULLIF([Vendor No_],'') AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
		,CAST(IIF(
				sku_aux.[Replenishment System] = 0
				AND LEN(sku_aux.[Lead Time Calculation]) > 0,
				nav.LeadTimeConvert(sku_aux.[Lead Time Calculation]),
				NULL) AS SMALLINT) AS PURCHASE_LEAD_TIME_DAYS
		,CAST(IIF(
				sku_aux.[Replenishment System] <> 0
				AND LEN(sku_aux.[Lead Time Calculation]) > 0,
				nav.LeadTimeConvert(sku_aux.[Lead Time Calculation]),
				NULL) AS SMALLINT) AS TRANSFER_LEAD_TIME_DAYS
		,CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS]
		,CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS]
		,CAST([Minimum Order Quantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY]
		,CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO]
		,CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE]
		,CAST([Unit Cost] AS DECIMAL(18,4)) AS [COST_PRICE]
		,CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE]
		--,CAST([Order Multiple] AS DECIMAL(18,4)) AS [ORDER_MULTIPLE]
		,CAST(CASE
				WHEN sku_aux.[Location Code]<>'01'
				THEN cc.[Default Box Size Sale]
				WHEN sku_aux.[Location Code]='01'
				THEN [Order Multiple]
				END AS DECIMAL(18,4)) AS [ORDER_MULTIPLE]
		,CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET]
		,CAST(NULL AS DECIMAL(18,4)) AS [VOLUME]
		,CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT]
		,CAST(IIF(s_sku.settingValue = 'true',1,NULL) AS BIT) AS [INCLUDE_IN_AGR]
		,CAST([Safety Stock Quantity] AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS]
        ,CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK]
		,CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
	FROM sku_aux
	INNER JOIN nav_cus.cc_transfer_multiple cc ON cc.[No_]=sku_aux.[Item No_]
	INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku_aux.[Location Code] --AND include = 1
	INNER JOIN core.setting s_sku ON s_sku.settingKey = 'data_mapping_bc_sku_as_assortment'
	--WHERE sku_aux.[Item No_]='0890 108 715'

