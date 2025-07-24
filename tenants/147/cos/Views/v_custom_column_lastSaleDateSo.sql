

-- ===============================================================================
-- Author:      Grétar Magnússon
-- Description: Custom Column mapping
--
--  12.03.2025.GM   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_custom_column_lastSaleDateSo]
AS
	
	SELECT
		ITEM_NO		AS itemNo,
		LOCATION_NO	AS locationNo,
		MAX(DATE)	AS lastSaleDateSo
	FROM
		adi.SALES_HISTORY
	GROUP BY
		ITEM_NO,
		LOCATION_NO


