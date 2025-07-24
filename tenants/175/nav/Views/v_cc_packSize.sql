

CREATE VIEW [nav_cus].[v_cc_packSize]
AS

	SELECT
		CAST(ix.[Item No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' 
                            ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [NO],
		CAST(ix.[Description] AS NVARCHAR(255)) AS [packSize]
	FROM nav_cus.ItemUnitofMeasure ix
	LEFT JOIN [nav].ItemVariant iv ON iv.[Item No_] = ix.[Item No_]
	INNER JOIN nav.Item i ON i.No_ = ix.[Item No_] AND i.[Purch_ Unit of Measure] = ix.[Code]



