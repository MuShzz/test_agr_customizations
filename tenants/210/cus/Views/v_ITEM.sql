CREATE VIEW [cus].v_ITEM AS

    SELECT
        CAST(ii.ItemCode AS NVARCHAR(255))                                  AS [NO],
        CAST(LEFT(iid.ItemDescription, 255) AS NVARCHAR(255))               AS [NAME],
        CAST(iid.ExtendedDescription AS NVARCHAR(1000))                     AS [DESCRIPTION],
        CAST(ispl.SupplierCode AS NVARCHAR(255))                            AS [PRIMARY_VENDOR_NO],
        CAST(iif(isp.LeadTime=0,NULL,isp.LeadTime) AS SMALLINT)             AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(s_transf_lead.settingValue AS SMALLINT)                        AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(s_ord_freq.settingValue AS SMALLINT)                           AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT)                                              AS [ORDER_COVERAGE_DAYS],
        CAST(ISNULL(isp.MOQ_C,0) AS DECIMAL(18,4))                          AS [MIN_ORDER_QTY],
        CAST(isp.PartCode AS NVARCHAR(50))                                  AS [ORIGINAL_NO],
        CAST(IIF(ii.Status IN ('A'),0,1) AS BIT)                            AS [CLOSED],
        CAST(NULL AS BIT)                                                   AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255))                                         AS [RESPONSIBLE],
        CAST(iipd.RetailPriceRate AS DECIMAL(18,4))                         AS [SALE_PRICE],
        CAST(ii.StandardCostRate AS DECIMAL(18,4))                          AS [COST_PRICE],
        CAST(ispl.BaseCost AS DECIMAL(18,4))                                AS [PURCHASE_PRICE],
        CAST(isp.UsualQtyOrder AS DECIMAL(18,4))                            AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4))                                         AS [QTY_PALLET],
        CAST(NULL AS DECIMAL(18,4))                                         AS [VOLUME],
        CAST(ium.WeightInKilograms AS decimal(18,4))                        AS [WEIGHT],
        CAST(NULL AS decimal(18,4))                                         AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS decimal(18,4))                                         AS [MIN_DISPLAY_STOCK],
        CAST(NULL AS decimal(18,4))                                         AS [MAX_STOCK],
        CAST(sc.ParentCategory AS nvarchar(255))                            AS [ITEM_GROUP_NO_LVL_1],
        CAST(ic.CategoryCode AS nvarchar(255))                              AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS nvarchar(255))                                         AS [ITEM_GROUP_NO_LVL_3],
        CAST(ium.UnitMeasureCode AS nvarchar(50))                           AS [BASE_UNIT_OF_MEASURE],
        CAST(NULL AS nvarchar(50))                                          AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(1 AS decimal(18,4))                                            AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS decimal(18,4))                                            AS [REORDER_POINT],
        CAST(IIF(IsIntendToStockItem_C=1,0,1) AS bit)                       AS [SPECIAL_ORDER],
        CAST(1 AS bit)                                                      AS [INCLUDE_IN_AGR]
	FROM cus.InventoryItem ii
	LEFT JOIN cus.InventoryItemDescription iid      ON iid.ItemCode=ii.ItemCode AND iid.LanguageCode='English - United Kingdom'
	LEFT JOIN cus.InventoryUnitMeasure ium          ON ium.ItemCode=ii.ItemCode AND ium.IsDefault=1
	OUTER APPLY (
				SELECT TOP 1 *
				FROM cus.InventorySupplierPricingLevel ispl_sub
				WHERE ispl_sub.ItemCode = ii.ItemCode AND ispl_sub.IsPriority = 1 AND ispl_sub.UnitMeasureCode=ium.UnitMeasureCode
				ORDER BY ispl_sub.LineNum desc 
			) ispl
	OUTER APPLY (
				SELECT TOP 1 *
				FROM cus.InventorySupplier isp_sub
				WHERE isp_sub.ItemCode = ii.ItemCode AND isp_sub.SupplierCode = ispl.SupplierCode
				ORDER BY isp_sub.DateModified ASC 
			) isp
	left join cus.InventoryItemPricingDetail iipd   on iipd.ItemCode=ii.ItemCode and CurrencyCode='GBP'
	LEFT JOIN cus.InventoryCategory ic              ON ic.ItemCode=ii.ItemCode AND ic.IsPrimary=1
	left join cus.SystemCategory SC                 on sc.CategoryCode=ic.CategoryCode and sc.IsActive=1
	INNER JOIN core.setting s_purch_lead            ON s_purch_lead.settingKey='data_mapping_lead_times_purchase_order_lead_time'
	INNER JOIN core.setting s_transf_lead           ON s_transf_lead.settingKey='data_mapping_lead_times_transfer_order_lead_time'
	INNER JOIN core.setting s_ord_freq              ON s_ord_freq.settingKey='inventory_order_frequency_days_default'
