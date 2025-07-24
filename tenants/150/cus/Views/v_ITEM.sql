
CREATE VIEW [cus].[v_ITEM] AS
	SELECT
		CAST(pd.[Code] AS NVARCHAR(255))									AS [NO],
		CAST(pd.[Description] AS NVARCHAR(255))								AS [NAME],
		CAST(pd.[Description] AS NVARCHAR(1000))							AS [DESCRIPTION],
		CAST(pd.[Purchasing.DefaultSupplier.Code] AS NVARCHAR(255))			AS [PRIMARY_VENDOR_NO],
		CAST(pd.[ReplenishmentSetup.LeadTimeQuantity] AS SMALLINT)			AS [PURCHASE_LEAD_TIME_DAYS],
		CAST(NULL AS SMALLINT)												AS [TRANSFER_LEAD_TIME_DAYS],
		CAST(NULL AS SMALLINT )												AS [ORDER_FREQUENCY_DAYS],
		CAST(NULL AS SMALLINT )												AS [ORDER_COVERAGE_DAYS],
		CAST(pd.[P_BranchInfo_STS.D_MinimumOrderQuantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
		CAST(pd.[Purchasing.SupplierProductCode] AS NVARCHAR(50))			AS [ORIGINAL_NO],
		CAST(IIF(pd.[Workflowstatus.Code] = '1',1,0) AS BIT)				AS [CLOSED],
		CAST(0 AS BIT)														AS [CLOSED_FOR_ORDERING],
		CAST(pd.[Buyer.Name] AS NVARCHAR(255))								AS [RESPONSIBLE],
		CAST(pd.[SellingPrice1] AS DECIMAL(18,4))							AS [SALE_PRICE],
		CAST(pd.[P_BranchInfo_STS.Costings.AverageCost] AS DECIMAL(18,4))					AS [COST_PRICE],
		CAST(NULL AS DECIMAL(18,4))											AS [PURCHASE_PRICE],
		CAST(pd.[Purchasing.PackSize] AS DECIMAL(18,4))						AS [ORDER_MULTIPLE],
		CAST(pd.[PalletQuantity] AS DECIMAL(18,4))							AS [QTY_PALLET],
		CAST(NULL AS DECIMAL(18,6))											AS [VOLUME],
		CAST(NULL AS DECIMAL(18,6))											AS [WEIGHT],
		CAST(NULL AS [DECIMAL] (18, 4))	AS [SAFETY_STOCK_UNITS],
		CAST(NULL AS [DECIMAL] (18, 4))										AS [MIN_DISPLAY_STOCK],
		CAST(pd.[P_BranchInfo_STS.MaximumStockLevel] AS DECIMAL(18,4))		AS [MAX_STOCK],
		CAST(pd.[Category.Code] AS NVARCHAR(255))							AS [ITEM_GROUP_NO_LVL_1],
		CAST('D' + pd.[Department.Code] AS NVARCHAR(255))					AS [ITEM_GROUP_NO_LVL_2],
		CAST(NULL AS NVARCHAR(255))											AS [ITEM_GROUP_NO_LVL_3],
		CAST(NULL AS NVARCHAR(50))											AS [BASE_UNIT_OF_MEASURE],
		CAST(NULL AS NVARCHAR(50))											AS [PURCHASE_UNIT_OF_MEASURE],
		CAST(1 AS DECIMAL(18,4))											AS [QTY_PER_PURCHASE_UNIT],
		CAST(0 AS BIT)														AS [SPECIAL_ORDER],
		CAST(0 AS DECIMAL(18,4))											AS [REORDER_POINT],
		CAST(0 AS BIT)						
		AS [INCLUDE_IN_AGR]
	FROM cus.ProductDetails pd

