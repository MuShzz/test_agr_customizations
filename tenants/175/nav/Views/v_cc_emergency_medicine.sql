

CREATE VIEW [nav_cus].[v_cc_emergency_medicine]
AS

	SELECT
		CAST(ix.[Item No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' 
                            ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [NO],
		CAST(ix.[Emergency] AS BIT) AS [Emergency_medicine]
	FROM nav_cus.cc_lyfjaverdskra ix
	LEFT JOIN [nav].ItemVariant iv ON iv.[Item No_] = ix.[Item No_]



