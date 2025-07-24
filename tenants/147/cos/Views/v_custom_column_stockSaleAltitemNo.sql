
-- ===============================================================================
-- Author:      Grétar Magnússon
-- Description: Custom Column mapping
--
--  07.04.2025.GM   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_custom_column_stockSaleAltitemNo]
AS
	
	SELECT
		e.ITEM_NO																																	AS itemNo
		,e.ALTItemNo																																AS ALTitemNo,
		STRING_AGG(CAST(s.total_stock_units AS INT), ', ') WITHIN GROUP (ORDER BY e.ALTItemNo ASC) + ' - ' +
		STRING_AGG(CAST(ISNULL(CAST(ss.total_sale_last_12M AS INT),0) AS NVARCHAR(255)), ', ') WITHIN GROUP (ORDER BY e.ALTItemNo ASC) + ' - ' +
		STRING_AGG(IIF(i.CLOSED = 0, 'Open', 'Closed'), ', ') WITHIN GROUP (ORDER BY e.ALTItemNo ASC)												AS [stockSaleAltitemNo]
	FROM
		cos_cus.AGR_ITEM_EXTRA_INFO e
		LEFT JOIN cos_cus.v_custom_column_total_stock s ON s.itemNo = e.ALTItemNo
		LEFT JOIN cos_cus.v_custom_column_total_sale_12M ss ON ss.itemNo = e.ALTItemNo
		LEFT JOIN adi.ITEM i ON i.NO = e.ALTItemNo
	WHERE
		e.ALTItemNo <> ''
		--AND e.ITEM_NO = '2825-2BL-034'
	GROUP BY
		e.ITEM_NO
		,e.ALTItemNo
		,i.CLOSED


