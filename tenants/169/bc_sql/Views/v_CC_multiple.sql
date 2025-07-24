
CREATE VIEW [bc_sql_cus].[v_CC_multiple] AS

	SELECT
		CAST(i.[No_] +
            IIF(iv.[Code] IS NULL OR iv.[Code] = '', '', '-' + iv.[Code]) AS NVARCHAR(255))		AS [NO],
		CAST(i.[IsfStatus Code] AS NVARCHAR(255))												AS itemstatus,
		CAST(b.Description AS NVARCHAR(255)) 													AS brand,
		CAST(iv.[IsfStatus Code] AS NVARCHAR(255)) 												AS variantStatus,
		CAST(c.Description AS NVARCHAR(255)) 													AS color,
		CAST(i.[Fmr_Extern Description 8] AS NVARCHAR(255))										AS commentFromNav
	FROM bc_sql_cus.ItemExtraInfo i
	INNER JOIN bc_sql_cus.ItemVariantExtraInfo iv ON i.No_=iv.[Item No_]
	LEFT JOIN 
		(SELECT Code, MAX(Description) AS Description 
		 FROM bc_sql_cus.CC_Brand 
		 GROUP BY Code) b ON b.Code = i.[IsfBrand Code]
	LEFT JOIN 
		(SELECT [Color Code], [Color Group Code], MAX(Description) AS Description 
		 FROM bc_sql_cus.CC_Color 
		 GROUP BY [Color Code], [Color Group Code]) c 
			ON c.[Color Code] = iv.[IsfColor Code] 
			AND c.[Color Group Code] = i.[IsfColor Group Code]


