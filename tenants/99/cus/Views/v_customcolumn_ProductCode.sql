


-- ===============================================================================
-- Author:      Astros Eir Kristinsdottir
-- Description: custom column, product code
--

-- ===============================================================================
CREATE    VIEW [cus].[v_customcolumn_ProductCode]
AS

    SELECT
        CAST(vd.vad_id AS NVARCHAR(255) ) AS vad_id,
        CAST(pd.pd_product_code AS NVARCHAR(255)) AS pd_product_code
	FROM cus.product_detail pd
	INNER JOIN cus.variant_detail vd on vd.vad_pd_id = pd.pd_id
   

