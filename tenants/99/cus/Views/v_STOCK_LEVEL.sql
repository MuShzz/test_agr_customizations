

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: stock level mapping from raw to adi, Orderwise
--
--  24.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_STOCK_LEVEL] AS
       SELECT
            CAST(vd.vad_id AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(sl.sl_id AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS EXPIRE_DATE,
            CAST(SUM(vsl.vsl_overall_stock_quantity) AS DECIMAL(18, 4)) AS [STOCK_UNITS]
       FROM cus.variant_stock_location vsl
	   INNER JOIN cus.variant_detail vd ON vd.vad_id = vsl.vsl_vad_id
	   INNER JOIN cus.stock_location sl ON sl.sl_id = vsl.vsl_sl_id
       GROUP BY  vd.vad_id, sl.sl_id 



