

-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns last days sale amount
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CC_totalSaleQtyLast30Days]
AS

    SELECT
        CAST(sh.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
        CAST(SUM(sh.SALE) AS DECIMAL(18,4)) AS totalSaleQtyLast30Days
    FROM
        adi.SALES_HISTORY sh
        JOIN core.location_mapping_setup lm ON lm.locationNo = sh.LOCATION_NO
	WHERE sh.DATE > GETDATE()-31
	GROUP BY sh.ITEM_NO



