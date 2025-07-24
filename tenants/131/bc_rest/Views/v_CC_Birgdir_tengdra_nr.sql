
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns for sum stock units related items
--
-- 19.03.2025.BF	Created
-- ===============================================================================

CREATE VIEW [bc_rest_cus].[v_CC_Birgdir_tengdra_nr]
AS

with cte_stock as  (
	SELECT 
		s.ITEM_NO, 
		lm.locationNo as location_no, 
		sum(s.STOCK_UNITS) as stock_units 
	  From  adi.STOCK_LEVEL  s 
	  inner join core.location_mapping_setup lm ON lm.locationNo=s.LOCATION_NO
	  group by s.ITEM_NO, lm.locationNo
	  )

SELECT 
	it.NO AS [ITEM_NO],
	il.LOCATION_NO,
	CAST(isnull(sub_1.stock_units,0) + isnull(sub_2.stock_units,0) +  + isnull(sub_3.stock_units,0)
	 AS INT) AS [BirgdirTengdraNr]
FROM adi.ITEM_LOCATION il
	INNER JOIN adi.item it ON it.NO=il.ITEM_NO
	INNER JOIN bc_rest_cus.item_extra_info iei ON iei.No=it.NO
	LEFT JOIN cte_stock sub_1 ON sub_1.item_no = iei.Substitute_1 and sub_1.LOCATION_NO = il.LOCATION_NO
	LEFT JOIN cte_stock sub_2 ON sub_2.item_no = iei.Substitute_2 and sub_2.LOCATION_NO = il.LOCATION_NO
	LEFT JOIN cte_stock sub_3 ON sub_3.item_no = iei.Substitute_3 and sub_3.LOCATION_NO = il.LOCATION_NO


