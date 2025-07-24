



-- ===============================================================================
-- Author:      JOSE SUCENA
-- Description: Mapping NAV item table to fit the ADI table
--
-- 10.10.2024.TO    Created
-- 22.01.2025.BF	Altered mapping of closed items - BDF-8
-- ===============================================================================

CREATE VIEW [nav_cus].[v_ITEM]
AS

     WITH qty_pallet_sub AS (
			 SELECT i.[No_], iuom_pallet.[Qty_ per Unit of Measure]
			   FROM [nav].Item i
		 INNER JOIN core.setting s_pallet ON s_pallet.settingKey = 'pallet_UOM_code_override'
		  LEFT JOIN [nav].ItemUnitofMeasure iuom_pallet ON iuom_pallet.[Item No_] = i.[No_]  
			  WHERE iuom_pallet.[Code] = COALESCE(s_pallet.settingValue, (SELECT Code FROM bc_rest.unit_of_measure WHERE [InternationalStandardCode] = 'PF'))
			)
	SELECT
        CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' 
                            ELSE '-' + iv.[Code] END AS NVARCHAR(255))                                              AS [NO],
        CAST(i.[Description] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' 
                                    ELSE ' - ' + iv.[Description] END AS NVARCHAR(255))                             AS [NAME],
        CAST(i.[Description 2] AS NVARCHAR(1000))                                                                   AS [DESCRIPTION],
        CAST(CASE WHEN ISNULL(v2.Blocked,0) <> 0 THEN 'vendor_closed' 
                  WHEN i.[Vendor No_] = '' OR v2.[No_] IS NULL THEN 'vendor_missing' 
                  ELSE i.[Vendor No_] END AS NVARCHAR(255))                                                         AS [PRIMARY_VENDOR_NO],
        CAST([nav].[LeadTimeConvert] (i.[Lead Time Calculation]) AS SMALLINT)                                       AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)                                                                                      AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT )                                                                                     AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT )                                                                                     AS [ORDER_COVERAGE_DAYS],
        CAST(i.[Minimum Order Quantity] AS DECIMAL(18,4))                                                           AS [MIN_ORDER_QTY],
        CAST(i.[Vendor Item No_] AS NVARCHAR(50))                                                                   AS [ORIGINAL_NO],
        --CAST(i.[Blocked] AS BIT)                                                                                  AS CLOSED,
		CAST(cci.delisted AS BIT)                                                                                   AS CLOSED,
        CAST(0 AS BIT)                                                                                              AS [CLOSED_FOR_ORDERING],
        CAST(v2.[Purchaser Code] AS NVARCHAR(255))                                                                  AS [RESPONSIBLE],
        CAST(i.[Unit Price] AS DECIMAL(18,4))                                                                       AS [SALE_PRICE],
        CAST(i.[Unit Cost] AS DECIMAL(18,4))                                                                        AS [COST_PRICE],
        CAST(i.[Last Direct Cost] AS DECIMAL(18,4))                                                                 AS [PURCHASE_PRICE],
        CAST(i.[Order Multiple] AS DECIMAL(18,4))                                                                   AS [ORDER_MULTIPLE],
        CAST(iuom_pallet.[Qty_ per Unit of Measure] AS DECIMAL(18,4))                                               AS [QTY_PALLET],
        CAST(i.[Unit Volume] AS DECIMAL(18,6))                                                                      AS [VOLUME],
        CAST(i.[Gross Weight] AS DECIMAL(18,6))                                                                     AS [WEIGHT],
        CAST(i.[Maximum Inventory] AS DECIMAL(18,4))                                                                AS [MAX_STOCK],
        CAST(i.[Item Category Code] AS NVARCHAR(255))                                                               AS [ITEM_GROUP_NO_LVL_1],
        nav.ProductGroupCode(i.[Item Category Code], i.[Product Group Code])                                        AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255))                                                                                 AS [ITEM_GROUP_NO_LVL_3],
        CAST(uom_base.[Description] AS NVARCHAR(50))                                                                AS [BASE_UNIT_OF_MEASURE],
        CAST(uom_purch.[Description] AS NVARCHAR(50))                                                               AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(iuom.[Qty_ per Unit of Measure] AS DECIMAL(18,4))                                                      AS [QTY_PER_PURCHASE_UNIT],
        CAST(CASE WHEN i.[Reordering Policy] = 3  AND CAST(s.settingValue as BIT) = 0 THEN 1 ELSE 0 END AS BIT)     AS [SPECIAL_ORDER],
        CAST(i.[Reorder Point] AS DECIMAL(18,4))                                                                    AS [REORDER_POINT],
        CAST(IIF(s_sku.settingValue = 'true',NULL,1) AS BIT)                                                        AS [INCLUDE_IN_AGR],
		CAST(i.[Safety Stock Quantity] AS DECIMAL(18,4))															AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))																					AS [MIN_DISPLAY_STOCK]
    FROM
        [nav].Item i
        LEFT JOIN [nav].UnitofMeasure uom_base ON uom_base.Code = i.[Base Unit of Measure]
        LEFT JOIN [nav].UnitofMeasure uom_purch ON uom_purch.Code = i.[Purch_ Unit of Measure]
        LEFT JOIN [nav].ItemUnitofMeasure iuom ON iuom.[Item No_] = i.[No_] AND iuom.[Code] = i.[Purch_ Unit of Measure]
        LEFT JOIN qty_pallet_sub iuom_pallet ON iuom_pallet.[No_] = i.[No_]
        LEFT JOIN [nav].ItemVariant iv ON iv.[Item No_] = i.[No_]
        LEFT JOIN [nav].ItemCategory c ON c.Code = i.[Item Category Code]
        LEFT JOIN [nav].Vendor v2 ON i.[Vendor No_]= v2.[No_]
		LEFT JOIN [nav_cus].[CustomColumns_Item] cci ON cci.[No_]=i.No_
        INNER JOIN core.setting s ON s.settingKey='disable_special_order_item_mapping'
        INNER JOIN core.setting s_repl ON s_repl.settingKey='data_mapping_bc_item_replenishment'
        INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
    WHERE
        i.[Type]  = 0
    AND 
        i.[Replenishment System] IN (SELECT value FROM STRING_SPLIT(core.get_setting_value('data_mapping_bc_item_replenishment'),';'))


