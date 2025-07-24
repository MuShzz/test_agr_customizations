
 CREATE VIEW [cus].[v_ITEM_LOCATION] AS
	WITH RankedVendParts AS 
			(SELECT *, ROW_NUMBER() OVER (PARTITION BY PartNum, VendorNum ORDER BY EffectiveDate DESC) AS RowNum FROM cus.VendPart),
		RankedPartXRefVend AS
			(SELECT *, ROW_NUMBER() OVER (PARTITION BY PartNum, VendorNum ORDER BY PurchaseDefault DESC) AS RowNum FROM cus.PartXRefVend)

          SELECT CAST(cpp.[PartNum] AS NVARCHAR(255))													AS [ITEM_NO]
				,CAST(cpp.[Plant] AS NVARCHAR(255))														AS [LOCATION_NO]
				,CAST(0 AS DECIMAL(18,4)) 																AS [REORDER_POINT]
				,CAST(NULL AS DECIMAL(18,4))															AS [SAFETY_STOCK_UNITS]
				,CAST(NULL AS DECIMAL(18,4))															AS [MIN_DISPLAY_STOCK]
				,CAST(cpp.[MaximumQty] AS DECIMAL(18,4)) 												AS [MAX_STOCK]
				,CAST(NULL AS BIT) 																		AS [CLOSED_FOR_ORDERING]
				,CAST(cpp.[BuyerID] AS NVARCHAR(255)) 													AS [RESPONSIBLE]
				,CAST(cp.[PartDescription] AS NVARCHAR(255))											AS [NAME]
				,CAST(cp.[PartDescription] AS NVARCHAR(1000))											AS [DESCRIPTION]
				,CAST(vd.[VendorID] AS NVARCHAR(255))													AS [PRIMARY_VENDOR_NO]
				,CAST(cpp.[LeadTime] AS SMALLINT) 														AS [PURCHASE_LEAD_TIME_DAYS]
				,CAST(NULL AS SMALLINT) 																AS [TRANSFER_LEAD_TIME_DAYS]
				,CAST(NULL AS SMALLINT) 																AS [ORDER_FREQUENCY_DAYS]
				,CAST(NULL AS SMALLINT) 																AS [ORDER_COVERAGE_DAYS]
				,CAST(IIF(cpp.SourceType='P',cpp.MinOrderQty, cpp.[MinMfgLotSize]) AS DECIMAL(18,4)) 	AS [MIN_ORDER_QTY]
				,CAST(IIF(cvp.VenPartNum='',pxv.VendPartNum,cvp.VenPartNum) AS NVARCHAR(50)) 			AS [ORIGINAL_NO]
				,CAST(NULL AS DECIMAL(18,4)) 															AS [SALE_PRICE]
				,CAST(NULL AS DECIMAL(18,4)) 															AS [COST_PRICE]
				,CAST(cvp.[BaseUnitPrice] AS DECIMAL(18,4)) 											AS [PURCHASE_PRICE]
				,CAST(cpp.[MfgLotMultiple] AS DECIMAL(18,4)) 											AS [ORDER_MULTIPLE]
				,CAST(NULL AS DECIMAL(18,4)) 															AS [QTY_PALLET]
				,CAST(NULL AS DECIMAL(18,4)) 															AS [VOLUME]
				,CAST(NULL AS DECIMAL(18,4)) 															AS [WEIGHT]
				,CAST(1 AS BIT)												    						AS [INCLUDE_IN_AGR]
				,CAST(ISNULL(cp.InActive,0) AS BIT) 													AS [CLOSED]
				,CAST(NULL AS BIT)																		AS [SPECIAL_ORDER]
		  FROM cus.Part cp
	INNER JOIN cus.PartPlant cpp ON cp.[PartNum] = cpp.[PartNum]
	 LEFT JOIN (SELECT * FROM RankedVendParts WHERE RowNum = 1) AS cvp ON cp.[PartNum] = cvp.[PartNum] AND cpp.[VendorNum] = cvp.[VendorNum] --AND cvp.[PrimaryVendor] = 1
	 LEFT JOIN cus.Vendor vd ON vd.VendorNum = cpp.[VendorNum]
	 LEFT JOIN (SELECT * FROM RankedPartXRefVend WHERE RowNum = 1) AS pxv ON pxv.PartNum=cp.PartNum AND pxv.VendorNum = cpp.VendorNum
		 WHERE cp.InActive = 0


