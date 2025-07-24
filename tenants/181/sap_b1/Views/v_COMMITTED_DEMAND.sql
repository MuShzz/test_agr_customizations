



CREATE VIEW [sap_b1_cus].[v_COMMITTED_DEMAND] AS

    SELECT
		CAST(WOR1.[ItemCode] AS NVARCHAR(128))	AS [ITEM_NO], 
		CAST(WOR1.[wareHouse] AS NVARCHAR(255))	AS [LOCATION_NO],          
		CAST(SUM(WOR1.[PlannedQty] - WOR1.[IssuedQty])		AS NVARCHAR(255)) AS [QUANTITY],  
		CAST(IIF(WOR1.[StartDate] < GETDATE(), GETDATE(), WOR1.[StartDate]) AS DATE)			AS [DEMAND_DATE] 
	FROM 
		[sap_b1_cus].WOR1 WOR1
	INNER JOIN
		[sap_b1_cus].OWOR OWOR ON WOR1.[DocEntry] = OWOR.[DocEntry]
	WHERE 
		WOR1.[ItemCode] IS NOT NULL
		AND WOR1.[wareHouse] IS NOT NULL
		AND WOR1.[StartDate] IS NOT NULL
		AND (OWOR.[Status] = 'P' OR OWOR.[Status] = 'R')
	GROUP BY 
		WOR1.[ItemCode], 
		WOR1.[wareHouse], 
		CAST(IIF(WOR1.[StartDate] < GETDATE(), GETDATE(), WOR1.[StartDate]) AS DATE)  

