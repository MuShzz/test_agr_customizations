
CREATE VIEW [dk_cus].[cc_OuterBox]
AS
    
    WITH 
	cust AS
	(
		  select im.ItemCode as itemNo, ipu.[Units.UnitQuantity] as columnValue
		FROM [dk].[import_products] im
		LEFT JOIN (select ItemCode, [Units.UnitQuantity] from [dk].import_product_units where [Units.UnitCode] = 'ytr.ks' ) ipu on ipu.ItemCode = im.ItemCode
		WHERE ipu.[Units.UnitQuantity] is not null
	)
	SELECT
		   aei.[itemNo]
		  ,aei.[locationNo]
		  ,3 AS customColumnId
		  ,cast(cust.columnValue as NVARCHAR(23)) as columnValue
	  FROM [dbo].[AGREssentials_items] aei
		INNER JOIN cust ON aei.[itemNo] = cust.[itemNo]
		WHERE cast(cust.columnValue as NVARCHAR(23)) <> '' 

