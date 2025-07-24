


-- ===============================================================================
-- Author:      Daniel Freyr Snorrason
-- Description: Custom Column mapping
--
--  19.02.2025.DFS   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_custom_column_stock_0300]
AS

	SELECT 
		i.itemNo
		,SUM(sl.STOCK_UNITS) AS stock_units_0300
	FROM dbo.AGREssentials_items i
	JOIN adi.STOCK_LEVEL sl ON sl.ITEM_NO = i .itemNo AND sl.LOCATION_NO = i.locationNo
	WHERE sl.LOCATION_NO = '0300'
	--AND i.itemNo = '20027-1150'
	GROUP BY i.itemNo


