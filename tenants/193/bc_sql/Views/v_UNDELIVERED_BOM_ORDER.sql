CREATE VIEW [bc_sql_cus].[v_UNDELIVERED_BOM_ORDER] AS

-- Production Orders finished goods

SELECT CAST(pol.[Prod_ Order No_] AS VARCHAR(128))                                                                           AS [BOM_ORDER_NO],
       CAST(pol.[Item No_] + CASE
                        WHEN ISNULL([Variant Code], '') = '' THEN ''
                        ELSE '-' + [Variant Code] END AS NVARCHAR(255))                                               AS [ITEM_NO],
       CAST([Location Code] AS NVARCHAR(255))                                                                         AS [LOCATION_NO],
       CAST(SUM(pol.[Remaining Quantity]) AS DECIMAL(18, 4))                                                         AS [QUANTITY],
       	CAST(
				CASE 
					--WHEN pol.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
					WHEN pol.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
					ELSE pol.[Due Date]
				END 
			AS DATE)																								 AS DELIVERY_DATE,
       ''                                                                                                     AS [Company]
FROM [bc_sql_cus].productionorderline pol
WHERE  pol.Status IN (2,3) -- Firm Planned,Released
		AND pol.[Remaining Quantity]>0
		--AND pol.[Due Date]>=GETDATE()
GROUP BY  
pol.[Prod_ Order No_],
pol.[Item No_], pol.[Variant Code],
pol.[Location Code],
CAST(
				CASE 
					--WHEN pol.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
					WHEN pol.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
					ELSE pol.[Due Date]
				END 
			AS DATE)
HAVING SUM(pol.[Remaining Quantity])>0

UNION ALL
 
--Assembly Orders

SELECT
		CAST(ah.No_ AS VARCHAR(128))										AS [BOM_ORDER_NO],
		 CAST(ah.[Item No_] + CASE
                        WHEN ISNULL(ah.[Variant Code], '') = '' THEN ''
                        ELSE '-' + ah.[Variant Code] END AS NVARCHAR(255))                                               AS [ITEM_NO],
		CAST(ah.[Location Code] AS NVARCHAR(255))                           AS [LOCATION_NO],
		CAST(SUM(ah.[Remaining Quantity (Base)]) AS DECIMAL(18, 4))             AS [QUANTITY],
		CAST(
				CASE 
					--WHEN ah.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
					WHEN ah.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
					ELSE ah.[Due Date]
				END 
			AS DATE)															AS DELIVERY_DATE,
		''                                                                   AS [Company]
	FROM bc_sql_cus.AssemblyHeader ah 
		INNER JOIN core.location_mapping_setup lms ON lms.locationNo=ah.[Location Code]
	WHERE ah.[Document Type] = 1
		AND ah.[Remaining Quantity (Base)] > 0
		--AND ah.[Due Date]>=GETDATE()
	GROUP BY 
		ah.No_,
		ah.[Item No_],
		ah.[Variant Code],
		ah.[Location Code],
		CAST(
		        CASE 
		            --WHEN ah.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
					WHEN ah.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
		            ELSE ah.[Due Date]
		        END 
		    AS DATE)
	HAVING SUM(ah.[Remaining Quantity (Base)])>0

	UNION all
	-- Production order components returned from production orders (extra components with minuses in the production orders)

		SELECT
		CAST(poc.[Prod_ Order No_] AS VARCHAR(128))                          AS [BOM_ORDER_NO],
		CAST(poc.[Item No_] AS NVARCHAR(255))                                AS [ITEM_NO],
		CAST(poc.[Location Code] AS NVARCHAR(255))                           AS [LOCATION_NO],
		CAST(SUM(poc.[Remaining Quantity]*-1) AS DECIMAL(18, 4))             AS [QUANTITY],
		CAST(
				CASE 
					--WHEN poc.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
					WHEN poc.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
					ELSE poc.[Due Date]
				END 
			AS DATE)																								 AS DELIVERY_DATE,
		''                                                                   AS [Company]
	FROM bc_sql.ProdOrderComponent poc
		INNER JOIN core.location_mapping_setup lms ON lms.locationNo=poc.[Location Code]
	WHERE poc.Status IN (2,3) -- Firm Planned,Released
		AND poc.[Remaining Quantity]<0
		--AND poc.[Due Date]>=GETDATE()
	GROUP BY 
		poc.[Prod_ Order No_], 
		poc.[Item No_],
		poc.[Location Code],
		CAST(
						CASE 
							--WHEN poc.[Due Date] <= CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
							WHEN poc.[Due Date] = '1753-01-01 00:00:00.000' THEN CAST(GETDATE() AS DATE)
							ELSE poc.[Due Date]
						END 
					AS DATE)



