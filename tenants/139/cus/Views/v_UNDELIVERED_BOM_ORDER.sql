



CREATE VIEW [cus].[v_UNDELIVERED_BOM_ORDER] AS
	SELECT
		CAST(Prod_Order_No AS VARCHAR(128))										AS [BOM_ORDER_NO],
		CAST(Item_No + CASE WHEN ISNULL(Variant_Code, '') = '' THEN '' 
							   ELSE '-' + Variant_Code END AS NVARCHAR(255))	AS [ITEM_NO],
		CAST(Location_Code AS NVARCHAR(255))									AS [LOCATION_NO],
		--CAST(Ending_Date AS DATE) 												AS [DELIVERY_DATE],
		CAST(Due_Date AS DATE) 												AS [DELIVERY_DATE],
		SUM(CAST(Remaining_Quantity AS DECIMAL(18, 4)))							AS [QUANTITY],
		Company
	FROM cus.ProductionOrderLine
	WHERE CAST(CAST(Remaining_Quantity AS DECIMAL(18,2)) AS INT)  > 0
	  AND Location_Code ='SF'
	  AND Status ='Firm Planned'
	GROUP BY Prod_Order_No,
			 CAST(Item_No + CASE WHEN ISNULL(Variant_Code, '') = '' THEN '' ELSE '-' + Variant_Code END AS NVARCHAR(255)),
			 Location_Code,
			 --Ending_Date,
			 Due_Date,
			 Company
	HAVING SUM(CAST(Remaining_Quantity AS DECIMAL(18, 4))) > 0

