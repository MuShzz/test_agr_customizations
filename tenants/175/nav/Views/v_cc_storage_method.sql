
CREATE VIEW [nav_cus].[v_cc_storage_method]
AS

	SELECT
		CAST(ix.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' 
                            ELSE '-' + iv.[Code] END AS NVARCHAR(255))                                              AS [NO],
		CASE WHEN ix.[Storage Method]=0 THEN '---'
			 WHEN ix.[Storage Method]=1 THEN '15-25°C'
			 WHEN ix.[Storage Method]=2 THEN '8-15°C'
			 WHEN ix.[Storage Method]=3 THEN '2-8°C'
			 WHEN ix.[Storage Method]=4 THEN '-5°C eða kaldara'
			 WHEN ix.[Storage Method]=5 THEN '-10 °C eða kaldara'
			 WHEN ix.[Storage Method]=6 THEN '-18°C eða kaldara'
			 WHEN ix.[Storage Method]=7 THEN '-70°C eða kaldara'
		END AS storageMethod
	FROM nav_cus.ItemExtraInfo ix
	LEFT JOIN [nav].ItemVariant iv ON iv.[Item No_] = ix.[No_]



