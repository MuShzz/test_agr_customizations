


-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns 
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CC_noos]
AS

    SELECT
        CAST(ix.No_ AS NVARCHAR(255)) AS ITEM_NO,
		TRY_CAST(NULLIF(LTRIM(REPLACE(ix.[NOOS$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8], '%', '')), '') AS TINYINT) AS noos,
		CAST(ix.[ICE LAG Status Code$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] AS NVARCHAR(20)) AS statusCode
    FROM
        bc_sql_cus.ItemExt ix



