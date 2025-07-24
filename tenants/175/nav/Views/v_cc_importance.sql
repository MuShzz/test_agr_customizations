
CREATE VIEW [nav_cus].[v_cc_importance]
AS

	WITH contracts AS(
		-- discounts
		SELECT 
			code AS ProductId,
			sld.[Sales Type],
			sld.[Sales Code],
			sld.[Contract No_],
			sld.[Ending Date],
			sld.[Type of Contract]
			--ix.[Deliv_ Performance Requirement]
		FROM nav_cus.SalesLineDiscount sld
		INNER JOIN nav.Item it ON it.No_=sld.Code
		INNER JOIN nav_cus.ItemExtraInfo ix ON ix.No_=it.No_
		WHERE sld.Type=0
			AND sld.[Sales Type] IN (0,1)
			AND ix.[Contract Item]=1

		UNION ALL
		--prices
		SELECT
			sp.[Item No_] AS ProductId,
			sp.[Sales Type],
			sp.[Sales Code],
			sp.[Contract No_],
			sp.[Ending Date],
			sp.[Type of Contract]
			--ix.[Deliv_ Performance Requirement]
		FROM nav_cus.SalesPrice sp
		--INNER JOIN nav_cus.ItemExtraInfo ix ON ix.No_=sp.[Item No_]
		WHERE sp.[Sales Type]=1
			AND sp.[Sales Code] IN ('LSH','2236')
			AND sp.[Type of Contract] IN (1,2,3)
			AND (sp.[Ending Date] >= GETDATE() OR sp.[Ending Date]='1753-01-01')
	)

	SELECT
		CAST(ix.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' 
                            ELSE '-' + iv.[Code] END AS NVARCHAR(255))				AS [NO],
		CAST(CASE WHEN (ix.[Deliv_ Performance Requirement]=3) THEN 1
				WHEN EXISTS (
							SELECT 1 
							FROM contracts c 
							WHERE c.ProductId = ix.No_
						)										  THEN 2
				 WHEN (ix.[Deliv_ Performance Requirement]=0) THEN 5
				 WHEN (ix.[Deliv_ Performance Requirement]=1) THEN 4
				 WHEN (ix.[Deliv_ Performance Requirement]=2) THEN 3
			 ELSE NULL
             END AS INT)															AS importance
	FROM nav_cus.ItemExtraInfo ix
	LEFT JOIN [nav].ItemVariant iv ON iv.[Item No_] = ix.No_



