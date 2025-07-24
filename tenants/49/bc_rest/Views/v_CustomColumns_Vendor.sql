
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom Columns Vendor Extra info
--
-- 26.11.2024.BF    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_CustomColumns_Vendor] AS
(
	 SELECT 
      i.NO AS No,
      v.minOrderPallets AS minOrderPallets, 
      v.minOrderAmount AS minOrderAmount, 
      v.minOrderCases AS minOrderCases, 
      v.minOrderCubage AS minOrderCubage
	FROM bc_rest.v_ITEM i 
	LEFT JOIN [bc_rest_cus].[CustomColumns_Vendor] v ON i.PRIMARY_VENDOR_NO = v.no
	--WHERE i.No='968-INTRO'


)

