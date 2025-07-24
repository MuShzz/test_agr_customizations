



-- ===============================================================================
-- Author:      Astros Eir Kristinsdottir
-- Description: custom column, product code
--

-- ===============================================================================
CREATE    VIEW [cus].[v_customcolumn_style]
AS

    SELECT
        CAST(vd.vad_id AS NVARCHAR(255) ) AS vad_id,
        CAST(pd.pd_abbv_description AS NVARCHAR(128)) AS pd_abbv_description
	FROM cus.product_detail pd
	INNER JOIN cus.variant_detail vd on vd.vad_pd_id = pd.pd_id
   

