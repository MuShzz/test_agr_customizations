-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Min stock and max stock overwrite values from Plus that needed to be loaded to SaaS HAG-54
--
-- 29.04.2025.BF    Created
-- ===============================================================================
CREATE VIEW [ax_cus].[v_min_max_plus_data] 
AS

       SELECT
            CAST(mm.item_no AS NVARCHAR(255))   AS item_no,
			CAST(mm.location_no AS NVARCHAR(255))   AS location_no,
			CAST(IIF(mm.min_stock_overwrite='NULL',NULL,min_stock_overwrite) AS DECIMAL(18,4))   AS min_stock_overwrite,
            CAST(IIF(mm.max_stock_overwrite='NULL',NULL,max_stock_overwrite) AS DECIMAL(18,4))   AS max_stock_overwrite
       FROM [ax_cus].min_max_plus_data mm
	   

