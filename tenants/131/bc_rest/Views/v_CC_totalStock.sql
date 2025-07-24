
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns total stock
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_CC_totalStock]
AS

    SELECT
        CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
        CAST(SUM(sl.STOCK_UNITS) AS DECIMAL(18,4)) AS totalStock
    FROM
        adi.STOCK_LEVEL sl
        JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO



