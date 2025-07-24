

CREATE VIEW [bc_rest_cus].[V_AGR_ITEM] AS
SELECT 
	CAST([No_] + CASE WHEN [SKU_Variant_Code] IS NULL OR [SKU_Variant_Code] = '' THEN '' ELSE '-' + [SKU_Variant_Code] END AS NVARCHAR(255)) AS [No_],
	[Manufacturer_Code],
	[Min_Del_DutyPaid_LCY] ,
	[SKU_Item_Type_Code],
	[SKU_Location_Code],
	[SKU_Variant_Code],
	[SKU_Reordering_Policy]
 FROM [bc_rest_cus].[AGR_ITEM]
WHERE [SKU_Location_Code] = 'MAG01'

