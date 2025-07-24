

CREATE VIEW [cus].[v_ITEM_LOCATION] AS
	SELECT 
		CAST(pd.[Code]AS NVARCHAR(255))											AS [ITEM_NO]
		,CAST(IIF(psb.[$StockBin.Code] IS NULL, '', psb.[$StockBin.Code]) AS NVARCHAR(255))	AS [LOCATION_NO]
		,CAST(0 AS DECIMAL(18,4)) 												AS [REORDER_POINT]
		,CAST(NULL AS [DECIMAL] (18, 4))										AS [SAFETY_STOCK_UNITS]
		,CAST(NULL AS [DECIMAL] (18, 4))										AS [MIN_DISPLAY_STOCK]
		,CAST(pd.[P_BranchInfo_STS.MaximumStockLevel]  AS DECIMAL(18,4))		AS [MAX_STOCK]
		,CAST(NULL AS BIT) 														AS [CLOSED_FOR_ORDERING]
		,CAST(pd.[Buyer.Name] AS NVARCHAR(255)) 								AS [RESPONSIBLE]
		,CAST(pd.[Description] AS NVARCHAR(255))								AS [NAME]
		,CAST(pd.[Description] AS NVARCHAR(1000))								AS [DESCRIPTION]
		,CAST(pd.[Purchasing.DefaultSupplier.Code]  AS NVARCHAR(255))			AS [PRIMARY_VENDOR_NO]
		,CAST(pd.[ReplenishmentSetup.LeadTimeQuantity] AS SMALLINT) 			AS [PURCHASE_LEAD_TIME_DAYS]
		,CAST(NULL AS SMALLINT) 												AS [TRANSFER_LEAD_TIME_DAYS]
		,CAST(NULL AS SMALLINT) 												AS [ORDER_FREQUENCY_DAYS]
		,CAST(NULL AS SMALLINT) 												AS [ORDER_COVERAGE_DAYS]
		,CAST(pd.[P_BranchInfo_STS.D_MinimumOrderQuantity]  AS DECIMAL(18,4)) 	AS [MIN_ORDER_QTY]
		,CAST(pd.[Purchasing.SupplierProductCode] AS NVARCHAR(50)) 				AS [ORIGINAL_NO]
		,CAST(pd.[SellingPrice1] AS DECIMAL(18,4)) 								AS [SALE_PRICE]
		,CAST(pd.[Purchasing.SellingBaseCost] AS DECIMAL(18,4)) 				AS [COST_PRICE]
		,CAST(NULL AS DECIMAL(18,4)) 											AS [PURCHASE_PRICE]
		,CAST(pd.[Purchasing.PackSize] AS DECIMAL(18,4)) 						AS [ORDER_MULTIPLE]
		,CAST(pd.[PalletQuantity] AS DECIMAL(18,4)) 							AS [QTY_PALLET]
		,CAST(NULL AS DECIMAL(18,4)) 											AS [VOLUME]
		,CAST(NULL AS DECIMAL(18,4)) 											AS [WEIGHT]
		,CAST(1 AS BIT)															AS [INCLUDE_IN_AGR]
        ,CAST(NULL AS BIT)                                    AS [SPECIAL_ORDER]
		,CAST(pd.[CALC_AGRClosed] AS BIT) 										AS [CLOSED]
	FROM cus.ProductDetails pd
	LEFT JOIN cus.ProductStockBin psb ON pd.Code = psb.Code
	LEFT JOIN cus.StockBin sb ON [sb].[Code] = [psb].[$StockBin.Code] 
	WHERE sb.[Status.Name] = 'Active' AND 1=0

