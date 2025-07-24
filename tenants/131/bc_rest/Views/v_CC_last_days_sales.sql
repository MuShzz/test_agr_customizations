
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns last days sale amount
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_CC_last_days_sales]
AS

    SELECT
        CAST(sh.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
        CAST(sh.LOCATION_NO AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(SUM(sh.SALE) AS DECIMAL(18,4)) AS lastDaysSales
    FROM
        adi.SALES_HISTORY sh
        JOIN core.location_mapping_setup lm ON lm.locationNo = sh.LOCATION_NO
	WHERE sh.DATE > GETDATE()-2
	GROUP BY sh.ITEM_NO, sh.LOCATION_NO




