
CREATE VIEW [bc_rest_cus].[v_CustomColumns_Item]
AS

    SELECT 
		CAST(i.[No] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255))		AS [NO],
		CAST(i.[ManufacturerCode] AS NVARCHAR(255)) AS ManufacturerCode
    FROM [bc_rest_cus].item i
       LEFT JOIN [bc_rest].item_variant iv ON iv.[ItemNo] = i.[No]
	

