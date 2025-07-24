

-- ===============================================================================
-- Author:      Astros Eir Kristinsdottir
-- Description: Item location mapping from bc rest to adi format
--
-- 28.03.2025.AEK    Created
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_ITEM_LOCATION]
AS

    SELECT CAST(sku.[ItemNo] + CASE WHEN sku.[VariantCode] = '' THEN '' ELSE '-' + sku.[VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO]
        ,CAST(sku.[LocationCode] AS NVARCHAR(255)) AS LOCATION_NO
        ,CAST(sku.[ReorderPoint] AS DECIMAL(18,4)) AS [REORDER_POINT]
        ,CAST(sku.[SafetyStockQuantity] AS DECIMAL(18,4)) AS SAFETY_STOCK_UNITS
        ,CAST(NULL AS DECIMAL(18,4)) AS MIN_DISPLAY_STOCK
        ,CAST(sku.[MaximumInventory] AS DECIMAL(18,4)) AS [MAX_STOCK]

		,CASE WHEN sku.[ReplenishmentMethod] = 'Transfer'
			THEN CAST(ISNULL(sku.[BlockTransferring],0) AS BIT)
			ELSE CAST(ISNULL(sku.[BlockPurchasing],0) AS BIT)
		END AS [CLOSED]

       -- ,CAST(NULL AS BIT) AS [CLOSED]
        ,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
        ,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
        ,CAST(NULL AS NVARCHAR(255)) AS [NAME]
        ,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
        ,CAST(NULLIF(sku.[VendorNo],'') AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
        ,CAST(IIF(sku.[ReplenishmentSystem]='Purchase',bc_rest.LeadTimeConvert(sku.[LeadTimeCalculation],GETDATE()),NULL) AS SMALLINT) AS PURCHASE_LEAD_TIME_DAYS
        ,CAST(IIF(sku.[ReplenishmentSystem]<>'Purchase',bc_rest.LeadTimeConvert(sku.[LeadTimeCalculation],GETDATE()),NULL) AS SMALLINT) AS TRANSFER_LEAD_TIME_DAYS
        ,CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS]
        ,CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS]
        ,CAST(sku.[MinimumOrderQuantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY]
        ,CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO]
        ,CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE]
        ,CAST(sku.[UnitCost] AS DECIMAL(18,4)) AS [COST_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE]

		 ,CASE WHEN sku.[ReplenishmentMethod] = 'Transfer'
			THEN CAST(sku.[TransferMultiple] AS DECIMAL(18,4))
			ELSE CAST(sku.[OrderMultiple] AS DECIMAL(18,4))
		END AS [ORDER_MULTIPLE]

       -- ,CAST(sku.[OrderMultiple] AS DECIMAL(18,4)) AS [ORDER_MULTIPLE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET]
        ,CAST(NULL AS DECIMAL(18,4)) AS [VOLUME]
        ,CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT]
		--,CAST(IIF(s_sku.settingValue = 'true',1,NULL) AS BIT) AS [INCLUDE_IN_AGR]
		,CAST(IIF(sku.[ExcludefromReplenishment] = 'False',1,0) AS BIT) AS [INCLUDE_IN_AGR]
		,CAST(NULL AS BIT)	AS [SPECIAL_ORDER]
    FROM bc_rest_cus.stock_keeping_unit sku
        INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.[LocationCode]
		INNER JOIN core.setting s_sku ON s_sku.settingKey='data_mapping_bc_sku_as_assortment'

