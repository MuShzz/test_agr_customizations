
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns for sum undelivered orders
--
-- 19.03.2025.BF	Created
-- ===============================================================================

create VIEW [bc_rest_cus].[v_CC_TengdVnrIPontun]
AS

SELECT 
	it.NO AS [ITEM_NO],
	il.LOCATION_NO,
	CAST(ISNULL((select sum(QUANTITY) from  adi.UNDELIVERED_PURCHASE_ORDER where ITEM_NO = sub_1.item_no),0) + 
	ISNULL((select sum(QUANTITY) from  adi.UNDELIVERED_PURCHASE_ORDER  where ITEM_NO = sub_2.item_no),0) + 
	ISNULL((select sum(QUANTITY) from  adi.UNDELIVERED_PURCHASE_ORDER where ITEM_NO = sub_3.item_no),0) +
	ISNULL((select sum(QUANTITY) from  adi.UNDELIVERED_TRANSFER_ORDER where ITEM_NO = sub_1.item_no),0) + 
	ISNULL((select sum(QUANTITY) from  adi.UNDELIVERED_TRANSFER_ORDER  where ITEM_NO = sub_2.item_no),0) + 
	ISNULL((select sum(QUANTITY) from  adi.UNDELIVERED_TRANSFER_ORDER where ITEM_NO = sub_3.item_no),0)
	 AS decimal (18,4)) AS [TengdVnrIPontun]
FROM adi.ITEM_LOCATION il
	INNER JOIN adi.item it ON it.NO=il.ITEM_NO
	INNER JOIN bc_rest_cus.item_extra_info iei ON iei.No=it.NO
	LEFT JOIN adi.ITEM_LOCATION sub_1 ON sub_1.item_no = iei.Substitute_1 and sub_1.LOCATION_NO = il.LOCATION_NO
	LEFT JOIN adi.ITEM_LOCATION sub_2 ON sub_2.item_no = iei.Substitute_2 and sub_2.LOCATION_NO = il.LOCATION_NO
	LEFT JOIN adi.ITEM_LOCATION sub_3 ON sub_3.item_no = iei.Substitute_3 and sub_3.LOCATION_NO = il.LOCATION_NO


