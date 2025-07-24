
-- ===============================================================================
-- Author:      Daniel Freyr Snorrason
-- Description: Custom Column mapping
--
--  20.02.2025.DFS   Created 
-- ===============================================================================
CREATE VIEW [cos_cus].[v_custom_column_stock_7009]
AS
    SELECT 
        i.itemNo,
        SUM(sl.STOCK_UNITS) AS stock_units_7009
    FROM dbo.AGREssentials_items i
    JOIN adi.STOCK_LEVEL sl 
        ON sl.ITEM_NO = i.itemNo 
       AND sl.LOCATION_NO = i.locationNo
    WHERE sl.LOCATION_NO = '7009'
    GROUP BY i.itemNo

