

-- ===============================================================================
-- Author:			Grétar Magnússon
-- Description:		Custom columns 
--
-- 13.05.2025.GM	Created
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_CC_replenishmentSystem]
AS

    SELECT
		CAST([Item No_] AS NVARCHAR(255)) AS ITEM_NO,
		CAST([Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(CASE WHEN [Replenishment System] = 0 THEN 'Innkaup'
				  WHEN [Replenishment System] = 1 THEN 'Framleiðslupöntun'
				  WHEN [Replenishment System] = 2 THEN 'Millifærsla'
				  WHEN [Replenishment System] = 3 THEN 'Samsetning'
				  ELSE '' END AS NVARCHAR(255)) AS replenishmentSystem
	FROM
		bc_sql.StockkeepingUnit
	--WHERE
	--	[Item No_] = 'P006409'


