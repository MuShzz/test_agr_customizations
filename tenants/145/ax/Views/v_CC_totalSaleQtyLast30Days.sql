
-- ===============================================================================
-- Author:			Grétar Magnússon
-- Description:		Custom columns total sale history 
--
-- 06.06.2025.GM	Created
-- ===============================================================================

CREATE VIEW [ax_cus].[v_CC_totalSaleQtyLast30Days]
AS

	SELECT
        CAST(sh.ITEM_NO AS NVARCHAR(255)) AS Item_No,
        CAST(SUM(sh.SALE) AS DECIMAL(18,4)) AS totalSaleQtyLast30Days
    FROM
        adi.SALES_HISTORY sh
        JOIN core.location_mapping_setup lm ON lm.locationNo = sh.LOCATION_NO
	WHERE
		sh.DATE > GETDATE()-31
		--AND sh.ITEM_NO = '1263'
	GROUP BY
		sh.ITEM_NO


