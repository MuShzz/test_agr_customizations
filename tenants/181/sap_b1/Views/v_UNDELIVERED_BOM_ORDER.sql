CREATE VIEW [sap_b1_cus].[v_UNDELIVERED_BOM_ORDER] AS
    SELECT
		CAST([DocNum] AS NVARCHAR(128))		AS BOM_ORDER_NO, 
		CAST([ItemCode] AS NVARCHAR(255))	AS ITEM_NO,          
		CAST([Warehouse]  AS NVARCHAR(255)) AS LOCATION_NO,  
		CAST([DueDate] AS DATE)				AS DELIVERY_DATE,  
		CAST([PlannedQty] - [CmpltQty]		AS DECIMAL(18,4))  AS QUANTITY   
	FROM 
		[sap_b1_cus].OWOR       
	WHERE 
		[Status] IN ('P','R')


