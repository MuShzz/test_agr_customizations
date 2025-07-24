


-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns last days sale amount
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CC_saleQtyLast7Days]
AS

    SELECT
        CAST(sh.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
        CAST('SKEMMAN' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(SUM(sh.SALE) AS DECIMAL(18,4)) AS saleQtyLast7Days
    FROM
        adi.SALES_HISTORY sh
        JOIN core.location_mapping_setup lm ON lm.locationNo = sh.LOCATION_NO
	WHERE
		sh.DATE > GETDATE()-8
		--AND sh.ITEM_NO = 'G001766'
	GROUP BY
		sh.ITEM_NO

	


