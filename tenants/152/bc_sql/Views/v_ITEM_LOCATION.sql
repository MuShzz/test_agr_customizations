

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Product assortment mapping from erp to adi format
--
--  07.05.2020.TO   Created
--  12.03.2025.BF	Bring cust from Plus setup: 
--						client doesnt use bc_sql.StockkeepingUnit isntead assortment is done on 
--						Changed min order qty, Purchase and transfer Lead time, order frequency days
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_ITEM_LOCATION] AS
    SELECT
        CAST(sku.[Item No_] AS NVARCHAR(255)) AS [ITEM_NO]
        ,CAST(sku.Location AS NVARCHAR(255)) AS [LOCATION_NO]
        ,CAST(i.[Reorder Point] AS DECIMAL(18,4)) AS [REORDER_POINT]
        ,CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS]
        ,CAST(mds.min_stock AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK]
        ,CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK]
        ,CAST(NULL AS BIT) AS [CLOSED]
        ,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
        ,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
        ,CAST(NULL AS NVARCHAR(255)) AS [NAME]
        ,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
        ,CAST(NULL AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
        ,CAST(IIF(sku.[Order From Type]=0, sku.[AGR Lead time], NULL) AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS]
		,CAST(IIF(sku.[Order From Type]=1, sku.[AGR Lead time], NULL) AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS]
		--,CAST(IIF(sku.[Replenishment System]=0,bc_sql.LeadTimeConvert(sku.[Lead Time Calculation]),NULL) AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS]
  --      ,CAST(IIF(sku.[Replenishment System]<>0,bc_sql.LeadTimeConvert(sku.[Lead Time Calculation]),NULL) AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS]
        ,CAST(sku.[Order Frequency (days)] AS SMALLINT) AS [ORDER_FREQUENCY_DAYS]
        ,CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS]
        ,CAST(sku.[Minimum Order Quantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY]
        ,CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO]
        ,CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE]
        ,CAST(sku.[Minimum Order Quantity] AS DECIMAL(18,4)) AS [ORDER_MULTIPLE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET]
        ,CAST(NULL AS DECIMAL(18,4)) AS [VOLUME]
        ,CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT]
        ,CAST(IIF(s_sku.settingValue = 'true',1,NULL) AS BIT) AS [INCLUDE_IN_AGR]
		,CAST(NULL AS BIT)	AS [SPECIAL_ORDER]
	FROM --bc_sql.StockkeepingUnit sku
		bc_sql.Item i
		INNER JOIN bc_sql_cus.OCAGRSKU sku ON sku.[Item No_]=i.No_
        INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.Location
        INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'
		LEFT JOIN bc_sql_cus.Min_Display_Stock mds ON mds.item_no=sku.[Item No_] AND mds.location_no=sku.Location
	


