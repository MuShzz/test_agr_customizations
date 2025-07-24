


-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns last days sale amount
--
-- 19.03.2025.BF	Created
-- 19.05.2025.GM	Adding in CASE statement to map correct onto locations
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CC_saleQtyLast7Days]
AS

    SELECT
        CAST(sh.ITEM_NO AS NVARCHAR(255))														AS ITEM_NO,
        CAST(CASE
				WHEN sh.LOCATION_NO = 'F-AKUREYRI' THEN 'AKUREYRI'
				WHEN sh.LOCATION_NO = 'F-GRANDI' THEN 'GRANDI'
				WHEN sh.LOCATION_NO = 'F-FITJAR' THEN 'FITJAR'
				WHEN sh.LOCATION_NO = 'F-SELFOSS' THEN 'SELFOSS'
				WHEN sh.LOCATION_NO = 'VÖRUHÚS_ÚT' THEN 'VÖRUHÚS'
				ELSE sh.LOCATION_NO
			 END AS NVARCHAR(255))									AS LOCATION_NO,
        CAST(SUM(sh.SALE) AS DECIMAL(18,4))														AS saleQtyLast7Days
    FROM
        adi.SALES_HISTORY sh
        JOIN core.location_mapping_setup lm ON lm.locationNo = sh.LOCATION_NO
	WHERE
		sh.DATE > GETDATE()-8
	GROUP BY
		sh.ITEM_NO, sh.LOCATION_NO



