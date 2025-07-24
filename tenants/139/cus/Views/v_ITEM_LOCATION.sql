

  CREATE VIEW [cus].[v_ITEM_LOCATION] AS
       SELECT
			CAST(i.No AS NVARCHAR(255))                  										AS [ITEM_NO],
			CAST(l.Code AS NVARCHAR(255))														AS [LOCATION_NO],
			CAST(NULL AS DECIMAL(18,4)) 														AS [SAFETY_STOCK_UNITS],
			CAST(NULL AS DECIMAL(18,4)) 														AS [MIN_DISPLAY_STOCK],
			CAST(NULL AS DECIMAL(18,4))                											AS [MAX_STOCK],
			CAST(0 AS BIT)                														AS [CLOSED],
			CAST(NULL AS BIT)                													AS [CLOSED_FOR_ORDERING],
			CAST(v2.PurchaserCode AS NVARCHAR(255))              								AS [RESPONSIBLE],
			CAST(NULL AS NVARCHAR(255))                     									AS [NAME],
			CAST(NULL AS NVARCHAR(1000))             											AS [DESCRIPTION],
			CAST(NULL AS NVARCHAR(255))        													AS [PRIMARY_VENDOR_NO],
			CAST([bc_rest].[LeadTimeConvert](i.[LeadTimeCalculation],GETDATE()) AS SMALLINT)	AS PURCHASE_LEAD_TIME_DAYS,
			CAST(NULL AS SMALLINT)																AS [TRANSFER_LEAD_TIME_DAYS],
			CAST(NULL AS SMALLINT)          													AS [ORDER_FREQUENCY_DAYS],
			CAST(NULL AS SMALLINT)           													AS [ORDER_COVERAGE_DAYS],
			CAST(NULL AS DECIMAL(18,4))            												AS [MIN_ORDER_QTY],
			CAST(NULL AS NVARCHAR(50))               											AS [ORIGINAL_NO],
			CAST(i.[UnitPrice] AS DECIMAL(18,4)) 												AS SALE_PRICE,
				CASE 
						WHEN LEN(CAST(FLOOR(dkk_cost_price.UnitCost) AS VARCHAR)) <= 14
						THEN CAST(dkk_cost_price.UnitCost AS DECIMAL(18,4)) 
						ELSE 0
						END  																	AS COST_PRICE,
				CASE 
						WHEN LEN(CAST(FLOOR(i.[LastDirectCost]) AS VARCHAR)) <= 14
						THEN CAST(i.[LastDirectCost] AS DECIMAL(18,4)) 
						ELSE 0
						END 																	AS PURCHASE_PRICE,
			CAST(NULL AS DECIMAL(18,4))           												AS [ORDER_MULTIPLE],
			CAST(NULL AS DECIMAL(18,4))               											AS [QTY_PALLET],
			CAST(NULL AS DECIMAL(18,4))                   										AS [VOLUME],
			CAST(NULL AS DECIMAL(18,4))                   										AS [WEIGHT],
			CAST(ISNULL(NULL,0) AS DECIMAL(18,4))  												AS [REORDER_POINT],
			CAST(IIF(s_sku.settingValue = 'true',NULL,1) as BIT) 								AS [INCLUDE_IN_AGR],
			CAST(NULL AS BIT)																	AS [SPECIAL_ORDER],
			CAST(i.Company AS NVARCHAR(255))													AS [company]
     FROM cus.item i
		LEFT JOIN cus.vendor v2 ON i.VendorNo=v2.No AND i.Company=v2.Company
		LEFT JOIN cus.Location l ON l.Company = i.Company 
		INNER JOIN core.location_mapping_setup lm ON lm.locationNo = l.Code
		INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
		LEFT JOIN (SELECT DISTINCT No,UnitCost FROM cus.item WHERE Company='PDK') dkk_cost_price ON dkk_cost_price.No = i.No
	--WHERE i.No='0399'

