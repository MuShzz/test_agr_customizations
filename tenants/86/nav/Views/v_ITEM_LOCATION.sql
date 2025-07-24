

-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Item location mapping from nav to adi format
--
-- 09.10.2024.TO    Created
-- 14.02.2025.BF	Applied temporary fix to the view to reduce the items listed, since we are doing filtering on nav.item
--					endpoints to exclude certain items, joining on that table to only include items listed in anv.item and not all in stockkeepingunits
-- 07.03.2025.BF	added filtering instead on nav.v_item since that can be reduced even more based on settings like exclude closed items
-- 10.06.2025.RDG	Changed primary_vendor_no to null to use the default vendor from nav.items
-- ===============================================================================


CREATE VIEW [nav_cus].[v_ITEM_LOCATION]
AS

     SELECT
		CAST(sku.[Item No_] + CASE WHEN sku.[Variant Code] = '' THEN '' ELSE '-' + sku.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO]
        ,CAST(sku.[Location Code] AS NVARCHAR(255)) AS LOCATION_NO
        ,CAST(sku.[Reorder Point] AS DECIMAL(18,4)) AS [REORDER_POINT]
        ,CAST(sku.[Safety Stock Quantity] AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS]
        ,CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK]
        ,CAST(sku.[Maximum Inventory] AS DECIMAL(18,4)) AS [MAX_STOCK]
        ,CAST(NULL AS BIT) AS [CLOSED]
        ,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
        ,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
        ,CAST(NULL AS NVARCHAR(255)) AS [NAME]
        ,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
        ,CAST(null AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
        ,CAST(IIF(
                sku.[Replenishment System] = 0
                AND LEN(sku.[Lead Time Calculation]) > 0,
                nav.LeadTimeConvert(sku.[Lead Time Calculation]),
                NULL) AS SMALLINT) AS PURCHASE_LEAD_TIME_DAYS
        ,CAST(IIF(
                sku.[Replenishment System] <> 0
                AND LEN(sku.[Lead Time Calculation]) > 0,
                nav.LeadTimeConvert(sku.[Lead Time Calculation]),
                NULL) AS SMALLINT) AS TRANSFER_LEAD_TIME_DAYS
        ,CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS]
        ,CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS]
        ,CAST(sku.[Minimum Order Quantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY]
        ,CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO]
        ,CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE]
        ,CAST(sku.[Unit Cost] AS DECIMAL(18,4)) AS [COST_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE]
        ,CAST(sku.[Order Multiple] AS DECIMAL(18,4)) AS [ORDER_MULTIPLE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET]
        ,CAST(NULL AS DECIMAL(18,4)) AS [VOLUME]
        ,CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT]
        ,CAST(IIF(s_sku.settingValue = 'true',1,NULL) AS BIT) AS [INCLUDE_IN_AGR]
		,CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
	FROM nav.StockkeepingUnit sku
		INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.[Location Code] --AND include = 1
		INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
	WHERE EXISTS (
		SELECT 1 FROM nav_cus.v_item i WHERE i.NO = sku.[Item No_]);


