CREATE VIEW [bc_sql_cus].[v_COMMITTED_DEMAND] AS

	
	WITH totaldemand AS (
	--assembly orders
	SELECT
		CAST(al.No_ AS NVARCHAR(255))                                AS [ITEM_NO],
		CAST(al.[Location Code] AS NVARCHAR(255))                           AS [LOCATION_NO],
		CAST(SUM(al.[Remaining Quantity (Base)]) AS DECIMAL(18, 4))             AS [QUANTITY],
		CAST(
				CASE 
					WHEN al.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
					WHEN al.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
					ELSE al.[Due Date]
				END 
			AS DATE)															AS DEMAND_DATE,
		''                                                                   AS [Company]
	FROM bc_sql.AssemblyLine al
		INNER JOIN bc_sql_cus.AssemblyHeader ah ON ah.No_=al.[Document No_]
		INNER JOIN core.location_mapping_setup lms ON lms.locationNo=al.[Location Code]
	WHERE al.[Document Type] = 1
		AND al.[Remaining Quantity (Base)] > 0
		--AND al.[Due Date]>=GETDATE()
	GROUP BY 
		al.No_,
		al.[Location Code],
		CAST(
		        CASE 
		            WHEN al.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
					WHEN al.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
		            ELSE al.[Due Date]
		        END 
		    AS DATE)
	
	UNION ALL
    
    --production orders
	SELECT
		CAST(poc.[Item No_] AS NVARCHAR(255))                                AS [ITEM_NO],
		CAST(poc.[Location Code] AS NVARCHAR(255))                           AS [LOCATION_NO],
		CAST(SUM(poc.[Remaining Quantity]) AS DECIMAL(18, 4))             AS [QUANTITY],
		CAST(
				CASE 
					WHEN poc.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
					WHEN poc.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
					ELSE poc.[Due Date]
				END 
			AS DATE)															AS DEMAND_DATE,
		''                                                                   AS [Company]
	FROM bc_sql.ProdOrderComponent poc
		INNER JOIN core.location_mapping_setup lms ON lms.locationNo=poc.[Location Code]
	WHERE poc.Status IN (2,3) -- Firm Planned,Released
		AND poc.[Remaining Quantity]>0
		--AND poc.[Due Date]>=GETDATE()
	GROUP BY 
		poc.[Item No_],
		poc.[Location Code],
		CAST(
						CASE 
							WHEN poc.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
							WHEN poc.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
							ELSE poc.[Due Date]
						END 
					AS DATE)

	UNION ALL
    
    --transfers orders from locations showed as committed demand
	SELECT
		CAST(tl.[Item No_] AS NVARCHAR(255))                                AS [ITEM_NO],
		CAST(tl.[Transfer-from Code] AS NVARCHAR(255))                      AS [LOCATION_NO],
		CAST(SUM(tl.[Outstanding Qty_ (Base)]) AS DECIMAL(18, 4))           AS [QUANTITY],
		CAST(tl.[Shipment Date] AS DATE)									AS DEMAND_DATE,
		''                                                                  AS [Company]
	FROM bc_sql.TransferLine tl
		INNER JOIN core.location_mapping_setup lms ON lms.locationNo = tl.[Transfer-from Code]
	WHERE tl.[Shipment Date]>GETDATE()
	GROUP BY tl.[Item No_], tl.[Transfer-from Code],tl.[Shipment Date]
		
	)

	SELECT 
	td.ITEM_NO,
	td.LOCATION_NO,
	SUM(td.QUANTITY) AS QUANTITY,
	td.DEMAND_DATE,
	td.Company
	FROM totaldemand td
	GROUP BY
	td.ITEM_NO,
	td.LOCATION_NO,
	td.DEMAND_DATE,
	td.Company
