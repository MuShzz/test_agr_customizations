

CREATE VIEW [nav2017_cus].[v_ITEM_LOCATION] AS
SELECT CAST(sku.[Item No_] +
            CASE WHEN sku.[Variant Code] = '' THEN '' ELSE '-' + sku.[Variant Code] END AS NVARCHAR(255))                 AS [ITEM_NO]
     , CAST(sku.[Location Code] AS NVARCHAR(255))                                                                     AS LOCATION_NO
     , CAST(sku.[Reorder Point] AS DECIMAL(18, 4))                                                                    AS [REORDER_POINT]
     , CAST(NULL AS DECIMAL(18, 4))                                                            AS [SAFETY_STOCK_UNITS] --07.07.2025.DFS ELKO-8 only use min and max on stores
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [MIN_DISPLAY_STOCK]
     , CAST(NULL AS DECIMAL(18, 4))                                                                AS [MAX_STOCK] --07.07.2025.DFS ELKO-8 only use min and max on stores
     , CAST(CASE
                WHEN i.Description LIKE '%#%' THEN 1
                ELSE 0
            END AS BIT)                                                                                          AS [CLOSED]
     , CAST(NULL AS BIT)                                                                                          AS [CLOSED_FOR_ORDERING]
     , CAST(NULL AS NVARCHAR(255))                                                                                AS [RESPONSIBLE]
     , CAST(NULL AS NVARCHAR(255))                                                                                AS [NAME]
     , CAST(NULL AS NVARCHAR(1000))                                                                               AS [DESCRIPTION]
     , CAST(NULLIF(sku.[Vendor No_], '') AS NVARCHAR(255))                                                            AS [PRIMARY_VENDOR_NO]
     , CAST(IIF(sku.[Replenishment System] = 0, nav2017.LeadTimeConvert(sku.[Lead Time Calculation]),
                NULL) AS SMALLINT)                                                                                AS PURCHASE_LEAD_TIME_DAYS
     , CAST(IIF(sku.[Replenishment System] <> 0, nav2017.LeadTimeConvert(sku.[Lead Time Calculation]),
                NULL) AS SMALLINT)                                                                                AS TRANSFER_LEAD_TIME_DAYS
     --,CAST(IIF([Replenishment System]=0,ISNULL(CASE WHEN RIGHT(CAST(sku.[Lead Time Calculation] AS NVARCHAR(255)), 1) = '' THEN LEFT(sku.[Lead Time Calculation], LEN(sku.[Lead Time Calculation]) - 1) ELSE sku.[Lead Time Calculation] END, 1),NULL) AS SMALLINT) AS PURCHASE_LEAD_TIME_DAYS
     --,CAST(IIF([Replenishment System]<>0,ISNULL(CASE WHEN RIGHT(CAST(sku.[Lead Time Calculation] AS NVARCHAR(255)), 1) = '' THEN LEFT(sku.[Lead Time Calculation], LEN(sku.[Lead Time Calculation]) - 1) ELSE sku.[Lead Time Calculation] END, 1),NULL) AS SMALLINT) AS TRANSFER_LEAD_TIME_DAYS
     , CAST(NULL AS SMALLINT)                                                                                     AS [ORDER_FREQUENCY_DAYS]
     , CAST(NULL AS SMALLINT)                                                                                     AS [ORDER_COVERAGE_DAYS]
     , CAST(sku.[Minimum Order Quantity] AS DECIMAL(18, 4))                                                           AS [MIN_ORDER_QTY]
     , CAST(NULL AS NVARCHAR(50))                                                                                 AS [ORIGINAL_NO]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [SALE_PRICE]
     , CAST(sku.[Unit Cost] AS DECIMAL(18, 4))                                                                        AS [COST_PRICE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [PURCHASE_PRICE]
     , CAST(sku.[Order Multiple] AS DECIMAL(18, 4))                                                                   AS [ORDER_MULTIPLE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [QTY_PALLET]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [VOLUME]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [WEIGHT]
     , CAST(IIF(s_sku.settingValue = 'true', 1, NULL) AS BIT)                                                     AS [INCLUDE_IN_AGR]
     , CAST(NULL AS BIT)                                                                                          AS [SPECIAL_ORDER]
FROM [nav2017].StockkeepingUnit sku
         INNER JOIN nav2017_cus.Item i ON sku.[Item No_] = i.No_
         INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.[Location Code] -- AND -- include = 1
         INNER JOIN core.setting s_sku ON s_sku.settingKey = 'data_mapping_bc_sku_as_assortment'
WHERE sku.[Location Code] IN ('60 BAKKINN', '72 FLE LAG') --07.07.2025.DFS ELKO-8 only use min and max on stores



UNION ALL

SELECT CAST([Item No_] +
            CASE WHEN [Variant Code] = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255))                 AS [ITEM_NO]
     , CAST([Location Code] AS NVARCHAR(255))                                                                     AS LOCATION_NO
     , CAST([Reorder Point] AS DECIMAL(18, 4))                                                                    AS [REORDER_POINT]
     , CAST(sku.[Reorder Point] AS DECIMAL(18, 4))                                                            AS [SAFETY_STOCK_UNITS] --07.07.2025.DFS ELKO-8 only use min and max on stores
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [MIN_DISPLAY_STOCK]
     , CAST(sku.[Maximum Inventory] AS DECIMAL(18, 4))                                                                AS [MAX_STOCK] --07.07.2025.DFS ELKO-8 only use min and max on stores
     , CAST(NULL AS BIT)                                                                                          AS [CLOSED]
     , CAST(NULL AS BIT)                                                                                          AS [CLOSED_FOR_ORDERING]
     , CAST(NULL AS NVARCHAR(255))                                                                                AS [RESPONSIBLE]
     , CAST(NULL AS NVARCHAR(255))                                                                                AS [NAME]
     , CAST(NULL AS NVARCHAR(1000))                                                                               AS [DESCRIPTION]
     , CAST(NULLIF([Vendor No_], '') AS NVARCHAR(255))                                                            AS [PRIMARY_VENDOR_NO]
     , CAST(IIF([Replenishment System] = 0, nav2017.LeadTimeConvert([Lead Time Calculation]),
                NULL) AS SMALLINT)                                                                                AS PURCHASE_LEAD_TIME_DAYS
     , CAST(IIF([Replenishment System] <> 0, nav2017.LeadTimeConvert([Lead Time Calculation]),
                NULL) AS SMALLINT)                                                                                AS TRANSFER_LEAD_TIME_DAYS
     --,CAST(IIF([Replenishment System]=0,ISNULL(CASE WHEN RIGHT(CAST(sku.[Lead Time Calculation] AS NVARCHAR(255)), 1) = '' THEN LEFT(sku.[Lead Time Calculation], LEN(sku.[Lead Time Calculation]) - 1) ELSE sku.[Lead Time Calculation] END, 1),NULL) AS SMALLINT) AS PURCHASE_LEAD_TIME_DAYS
     --,CAST(IIF([Replenishment System]<>0,ISNULL(CASE WHEN RIGHT(CAST(sku.[Lead Time Calculation] AS NVARCHAR(255)), 1) = '' THEN LEFT(sku.[Lead Time Calculation], LEN(sku.[Lead Time Calculation]) - 1) ELSE sku.[Lead Time Calculation] END, 1),NULL) AS SMALLINT) AS TRANSFER_LEAD_TIME_DAYS
     , CAST(NULL AS SMALLINT)                                                                                     AS [ORDER_FREQUENCY_DAYS]
     , CAST(NULL AS SMALLINT)                                                                                     AS [ORDER_COVERAGE_DAYS]
     , CAST([Minimum Order Quantity] AS DECIMAL(18, 4))                                                           AS [MIN_ORDER_QTY]
     , CAST(NULL AS NVARCHAR(50))                                                                                 AS [ORIGINAL_NO]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [SALE_PRICE]
     , CAST([Unit Cost] AS DECIMAL(18, 4))                                                                        AS [COST_PRICE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [PURCHASE_PRICE]
     , CAST([Order Multiple] AS DECIMAL(18, 4))                                                                   AS [ORDER_MULTIPLE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [QTY_PALLET]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [VOLUME]
     , CAST(NULL AS DECIMAL(18, 4))                                                                               AS [WEIGHT]
     , CAST(IIF(s_sku.settingValue = 'true', 1, NULL) AS BIT)                                                     AS [INCLUDE_IN_AGR]
     , CAST(NULL AS BIT)                                                                                          AS [SPECIAL_ORDER]
FROM [nav2017].StockkeepingUnit sku
         INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.[Location Code] -- AND -- include = 1
         INNER JOIN core.setting s_sku ON s_sku.settingKey = 'data_mapping_bc_sku_as_assortment'
WHERE sku.[Location Code]  NOT IN ('60 BAKKINN', '72 FLE LAG') --07.07.2025.DFS ELKO-8 only use min and max on stores


