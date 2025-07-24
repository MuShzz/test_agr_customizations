CREATE VIEW [bc_sql_cus].[v_ITEM] AS

WITH qty_pallet_sub AS (SELECT i.[No_], iuom_pallet.[Qty_ per Unit of Measure], i.[company]
                        FROM [bc_sql].Item i
                                 INNER JOIN core.setting s_pallet ON s_pallet.settingKey = 'pallet_UOM_code_override'
                                 LEFT JOIN [bc_sql].ItemUnitofMeasure iuom_pallet
                                           ON iuom_pallet.[Item No_] = i.[No_] and i.[company] = iuom_pallet.[company]
                        WHERE iuom_pallet.[Code] = COALESCE(s_pallet.settingValue, (SELECT Code
                                                                                    FROM bc_sql.UnitofMeasure
                                                                                    WHERE [International Standard Code] = 'PF'
                                                                                      AND iuom_pallet.[company] = [company]
                                                                                      AND iuom_pallet.Code = [Code])))
SELECT CAST(i.[No_] +
            IIF(iv.[Code] IS NULL OR iv.[Code] = '', '', '-' + iv.[Code]) AS NVARCHAR(255)) AS [NO],
       CAST(i.[Description] + CASE
                                  WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN ''
                                  ELSE ' - ' + iv.[Description] END AS NVARCHAR(255))       AS [NAME],
       CAST(i.[Description 2] AS NVARCHAR(1000))                                            AS [DESCRIPTION],
       CAST(CASE
                WHEN ISNULL(v2.Blocked, 0) <> 0 THEN 'vendor_closed'
                WHEN i.[Vendor No_] = '' OR v2.[No_] IS NULL THEN 'vendor_missing'
                ELSE i.[Vendor No_] END AS NVARCHAR(255))                                   AS [PRIMARY_VENDOR_NO],
       --CAST(bc_sql.LeadTimeConvert(i.[Lead Time Calculation]) AS smallint)                  AS [PURCHASE_LEAD_TIME_DAYS],
	   CAST(ISNULL(CASE 
						WHEN i.[Replenishment System]=1 THEN rt.routing_time 
						ELSE bc_sql.LeadTimeConvert(itv.[Lead Time Calculation]) 
						END,0) AS smallint)													AS [PURCHASE_LEAD_TIME_DAYS],
       CAST(NULL as smallint)                                                               AS [TRANSFER_LEAD_TIME_DAYS],
       CAST(NULL as smallint)                                                               AS [ORDER_FREQUENCY_DAYS],
       CAST(NULL as smallint)                                                               AS [ORDER_COVERAGE_DAYS],
       CAST(i.[Minimum Order Quantity] AS DECIMAL(18, 4))                                   AS [MIN_ORDER_QTY],
       CAST(i.[Vendor Item No_] AS NVARCHAR(255))                                           AS [ORIGINAL_NO],
       CAST(i.[Blocked] AS BIT)                                                             AS [CLOSED],
       CAST(i.[Purchasing Blocked] AS BIT)                                                  AS [CLOSED_FOR_ORDERING],
       CAST(ISNULL(v2.[Purchaser Code], '') AS NVARCHAR(255))                               AS [RESPONSIBLE],
       CAST(i.[Unit Price] AS DECIMAL(18, 4))                                               AS [SALE_PRICE],
       CAST(i.[Unit Cost] AS DECIMAL(18, 4))                                                AS [COST_PRICE],
       CAST(i.[Last Direct Cost] AS DECIMAL(18, 4))                                         AS [PURCHASE_PRICE],
       CAST(i.[Order Multiple] AS DECIMAL(18, 4))                                           AS [ORDER_MULTIPLE],
       CAST(i.[Unit Volume] AS DECIMAL(18, 6))                                              AS [VOLUME],
       CAST(i.[Gross Weight] AS DECIMAL(18, 6))                                             AS [WEIGHT],
       CAST(i.[Safety Stock Quantity] AS DECIMAL(18, 4))                                    AS [SAFETY_STOCK_UNITS],
       CAST(NULL AS DECIMAL(18, 4))                                                         AS [MIN_DISPLAY_STOCK],
       CAST(i.[Maximum Inventory] AS DECIMAL(18, 4))                                        AS [MAX_STOCK],
       CAST(iuom_pallet.[Qty_ per Unit of Measure] AS DECIMAL(18, 4))                       AS [QTY_PALLET],
       CAST(uom_base.[Description] AS NVARCHAR(50))                                         AS [BASE_UNIT_OF_MEASURE],
       CAST(uom_purch.[Description] AS NVARCHAR(50))                                        AS [PURCHASE_UNIT_OF_MEASURE],
       CAST(iuom.[Qty_ per Unit of Measure] AS DECIMAL(18, 4))                              AS [QTY_PER_PURCHASE_UNIT],
       CAST(CASE
                WHEN c.[Parent Category] <> '' THEN c.[Parent Category]
                ELSE i.[Item Category Code] END AS NVARCHAR(255))                           AS [ITEM_GROUP_NO_LVL_1],
       CAST(CASE
                WHEN c.[Parent Category] <> '' THEN i.[Item Category Code]
                ELSE '' END AS NVARCHAR(255))                                               AS [ITEM_GROUP_NO_LVL_2],
       CAST(NULL AS NVARCHAR(255))                                                          AS [ITEM_GROUP_NO_LVL_3],
       CAST(IIF(i.[Reordering Policy] = 3 AND CAST(s.settingValue as BIT) = 0, 1,
                0) AS BIT)                                                                  AS [SPECIAL_ORDER], -- 1=Fixed Reorder Qty. 2=Maximum Qty. 3=Order 4=Lot-for-Lot
       CAST(i.[Reorder Point] AS DECIMAL(18, 4))                                            AS [REORDER_POINT],
       CAST(IIF(s_sku.settingValue = 'true', NULL, 1) as BIT)                               AS [INCLUDE_IN_AGR],
       i.[company]                                                                          as [Company]
FROM [bc_sql].Item i
         LEFT JOIN [bc_sql].UnitofMeasure uom_base
                   ON uom_base.Code = i.[Base Unit of Measure] and i.[company] = uom_base.[company]
         LEFT JOIN [bc_sql].UnitofMeasure uom_purch
                   ON uom_purch.Code = i.[Purch_ Unit of Measure] and i.[company] = uom_purch.[company]
         LEFT JOIN [bc_sql].ItemUnitofMeasure iuom
                   ON iuom.[Item No_] = i.[No_] AND iuom.[Code] = i.[Purch_ Unit of Measure] and
                      i.[company] = iuom.[company]
         LEFT JOIN qty_pallet_sub iuom_pallet ON iuom_pallet.[No_] = i.[No_] and i.[company] = iuom_pallet.[company]
         LEFT JOIN [bc_sql].ItemVariant iv ON iv.[Item No_] = i.[No_] and i.[company] = iv.[company]
         LEFT JOIN [bc_sql].ItemCategory c ON c.Code = i.[Item Category Code] and i.[company] = c.[company]
         LEFT JOIN [bc_sql].Vendor v2 ON i.[Vendor No_] = v2.[No_] and i.[company] = v2.[company]
         INNER JOIN core.setting s on s.settingKey = 'disable_special_order_item_mapping'
         INNER JOIN core.setting s_repl ON s_repl.settingKey = 'data_mapping_bc_item_replenishment'
         INNER JOIN core.setting s_sku ON s_sku.settingKey = 'data_mapping_bc_sku_as_assortment'
		 LEFT JOIN bc_sql_cus.v_routing_time rt ON rt.item_no=i.No_
		 LEFT JOIN bc_sql_cus.ItemVendor itv ON itv.[Item No_]=i.No_ AND itv.[Vendor No_]=i.[Vendor No_] AND itv.company = i.company
WHERE i.[Type] = 0 -- Inventory items only
  AND i.[Replenishment System] IN
      (SELECT value FROM STRING_SPLIT(core.get_setting_value('data_mapping_bc_item_replenishment'), ';'))


