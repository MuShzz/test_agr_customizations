
CREATE VIEW [dk_cus].[cc_BoxQty]
AS
    
    WITH 
	cust AS
	(
	  SELECT im.ItemCode as itemNo, ipu.[Units.UnitQuantity] as columnValue
		FROM [dk].[import_products] im
		LEFT JOIN (select ItemCode, [Units.UnitQuantity] from [dk].import_product_units where [Units.UnitCode] = 'kassi' ) ipu on ipu.ItemCode = im.ItemCode
		WHERE ipu.[Units.UnitQuantity] is not null
	)
	SELECT
		   aei.[itemNo]
		  ,aei.[locationNo]
		  ,2 AS customColumnId
		  ,cast(cust.columnValue as NVARCHAR(23)) as columnValue
	  FROM [dbo].[AGREssentials_items] aei
		INNER JOIN cust ON aei.[itemNo] = cust.[itemNo]
		WHERE cast(cust.columnValue as NVARCHAR(23)) <> '' 

