

-- ===============================================================================
-- Author:      Daniel Freyr Snorrason
-- Description: Custom Column mapping
--
--  19.02.2025.DFS   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_custom_column_stock_HUSASMIDJAN]
AS

	SELECT 
		i.NO AS itemNo
		,SUM(sl.STOCK_UNITS) AS stock_units_husasmidjan
	FROM adi.ITEM i
	JOIN cos.AGR_STOCK_LEVEL sl ON sl.ITEM_NO = i.NO --AND sl.LOCATION_NO = i.locationNo
	WHERE sl.LOCATION_NO LIKE 'Z%'
	--AND i.NO = '38981-094'
	GROUP BY i.NO


