CREATE VIEW [bc_rest_cus].[v_custom_columns]
AS

	SELECT DISTINCT lsi.[no]
		  ,lsi.[division_code]
		  ,lsi.[retail_product_group]
		  ,lsi.[item_category_code]
		  ,CONCAT(i.No,'-',iv.Code) AS agr_item_no
		  ,lsivr.variant_dimension_1
		  ,lsivr.variant_dimension_2
	  FROM [bc_rest_cus].[lsritem] lsi
	  LEFT JOIN bc_rest.item i ON i.No = lsi.no
	  LEFT JOIN bc_rest.item_variant iv ON iv.ItemNo = i.No
	  LEFT JOIN dbo.AGREssentials_items AEi ON AEi.itemNo = CONCAT(i.No,'-',iv.Code)
	  LEFT JOIN bc_rest_cus.lsivr lsivr ON CONCAT(lsivr.item_no,'-',lsivr.variant_code) = AEi.itemNo



