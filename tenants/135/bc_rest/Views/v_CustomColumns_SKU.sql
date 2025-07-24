
CREATE VIEW [bc_rest_cus].[v_CustomColumns_SKU]
AS

    SELECT 
		CAST(sku.[ItemNo] + CASE WHEN sku.[VariantCode] = '' THEN '' ELSE '-' + sku.[VariantCode] END AS NVARCHAR(255)) AS ItemNo,
		CAST(sku.[LocationCode] AS NVARCHAR(255)) AS LocationCode,
		CAST(sku.[TransferfromCode] AS NVARCHAR(255)) AS TransferfromCode
    FROM bc_rest.stock_keeping_unit sku
        INNER JOIN core.location_mapping_setup lm ON lm.locationNo = sku.[LocationCode]
	

