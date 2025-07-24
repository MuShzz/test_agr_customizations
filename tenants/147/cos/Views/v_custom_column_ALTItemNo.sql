



-- ===============================================================================
-- Author:      Grétar Magnússon
-- Description: Custom Column mapping
--
--  02.04.2025.GM   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_custom_column_ALTItemNo]
AS
	
	SELECT
		ITEM_NO AS itemNo
		,ALTItemNo
		,ITEMNAME3
	FROM
		cos_cus.AGR_ITEM_EXTRA_INFO
	WHERE
		ALTItemNo <> ''
		OR ITEMNAME3 <> ''


