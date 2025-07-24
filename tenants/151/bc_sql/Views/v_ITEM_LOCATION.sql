

CREATE VIEW [bc_sql_cus].[v_ITEM_LOCATION] AS

SELECT CAST(sku.[Item No_] +
            CASE WHEN sku.[Variant Code] = '' THEN '' ELSE '-' + sku.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO]
     , CAST(sku.[Location Code] AS NVARCHAR(255))                                                         AS [LOCATION_NO]
     , CAST(sku.[Reorder Point] AS DECIMAL(18, 4))                                                        AS [REORDER_POINT]
     , CAST(sku.[Safety Stock Quantity] AS DECIMAL(18, 4))                                                AS [SAFETY_STOCK_UNITS]
     , CAST(NULL AS DECIMAL(18, 4))                                                                       AS [MIN_DISPLAY_STOCK]
     , CAST(sku.[Maximum Inventory] AS DECIMAL(18, 4))                                                    AS [MAX_STOCK]
     , CAST(NULL AS BIT)                                                                                  AS [CLOSED]
     , CAST(NULL AS BIT)                                                                                  AS [CLOSED_FOR_ORDERING]
     , CAST(NULL AS NVARCHAR(255))                                                                        AS [RESPONSIBLE]
     , CAST(NULL AS NVARCHAR(255))                                                                        AS [NAME]
     , CAST(NULL AS NVARCHAR(1000))                                                                       AS [DESCRIPTION]
     , CAST(NULLIF(sku.[Vendor No_], '') AS NVARCHAR(255))                                                AS [PRIMARY_VENDOR_NO]
     , CAST(IIF(sku.[Replenishment System] = 0, bc_sql.LeadTimeConvert(sku.[Lead Time Calculation]),
                NULL) AS SMALLINT)                                                                        AS [PURCHASE_LEAD_TIME_DAYS]
     , CAST(IIF(sku.[Replenishment System] <> 0, bc_sql.LeadTimeConvert(sku.[Lead Time Calculation]),
                NULL) AS SMALLINT)                                                                        AS [TRANSFER_LEAD_TIME_DAYS]
     , CAST(NULL AS SMALLINT)                                                                             AS [ORDER_FREQUENCY_DAYS]
     , CAST(NULL AS SMALLINT)                                                                             AS [ORDER_COVERAGE_DAYS]
     , CAST(sku.[Minimum Order Quantity] AS DECIMAL(18, 4))                                               AS [MIN_ORDER_QTY]
     , CAST(NULL AS NVARCHAR(50))                                                                         AS [ORIGINAL_NO]
     , CAST(NULL AS DECIMAL(18, 4))                                                                       AS [SALE_PRICE]
     , CAST(sku.[Unit Cost] AS DECIMAL(18, 4))                                                            AS [COST_PRICE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                       AS [PURCHASE_PRICE]
     , CAST(sku.[Order Multiple] AS DECIMAL(18, 4))                                                       AS [ORDER_MULTIPLE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                       AS [QTY_PALLET]
     , CAST(NULL AS DECIMAL(18, 4))                                                                       AS [VOLUME]
     , CAST(NULL AS DECIMAL(18, 4))                                                                       AS [WEIGHT]
     , CAST(IIF(s_sku.settingValue = 'true', 1, NULL) AS BIT)                                             AS [INCLUDE_IN_AGR]
     , CAST(CASE WHEN sku.[Location Code] IN ('602110','602111','602112','702330') THEN 1 
					 ELSE 0 END AS BIT) 															      AS [SPECIAL_ORDER]
	 , sku.[company]																					  AS [Company]
FROM bc_sql.StockkeepingUnit sku
         INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.[Location Code]
         INNER JOIN core.setting s_sku ON s_sku.settingKey = 'data_mapping_bc_sku_as_assortment'


