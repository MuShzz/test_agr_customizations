

CREATE VIEW [nav_cus].[v_cc_contractItem]
AS

	SELECT
		CAST(iex.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' 
								ELSE '-' + iv.[Code] END AS NVARCHAR(255))                                              AS ITEM_NO,
		CAST(IIF(iex.[Contract Item]=1,1,0) AS BIT) AS contractItem
	FROM nav_cus.ItemExtraInfo iex
	LEFT JOIN [nav].ItemVariant iv ON iv.[Item No_] = iex.[No_]


