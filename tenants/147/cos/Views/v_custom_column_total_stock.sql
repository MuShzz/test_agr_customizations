

-- ===============================================================================
-- Author:      Daniel Freyr Snorrason
-- Description: Custom Column mapping
--
--  19.02.2025.DFS   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_custom_column_total_stock]
AS

	SELECT 
		i.itemNo
		,SUM(sl.STOCK_UNITS) AS total_stock_units
	FROM dbo.AGREssentials_items i
	JOIN adi.STOCK_LEVEL sl ON sl.ITEM_NO = i .itemNo AND sl.LOCATION_NO = i.locationNo
	--WHERE i.itemNo = '20027-1150'
	GROUP BY i.itemNo


