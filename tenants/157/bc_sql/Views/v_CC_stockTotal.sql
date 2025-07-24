


-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns total stock
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CC_stockTotal]
AS

    SELECT
        CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
        CAST(SUM(sl.STOCK_UNITS) AS DECIMAL(18,4)) AS stockTotal
    FROM
        adi.STOCK_LEVEL sl
        JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	WHERE 
		sl.LOCATION_NO NOT LIKE 'G-%' --Added in because G- locations stock should not be in total stock
	GROUP BY sl.ITEM_NO


