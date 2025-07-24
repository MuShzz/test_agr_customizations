
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns Last sale date Total across all locations
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_CC_lastSaleDateTotal]
AS

    SELECT
        CAST(sh.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
        CAST(MAX(sh.DATE) AS DATE) AS lastSaleDateTotal
    FROM
        adi.SALES_HISTORY sh
        JOIN core.location_mapping_setup lm ON lm.locationNo = sh.LOCATION_NO
	GROUP BY sh.ITEM_NO



