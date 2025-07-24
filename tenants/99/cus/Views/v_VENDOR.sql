

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: vendor mapping from raw to adi, Orderwise
--
--  24.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST(sd_id AS NVARCHAR(255)) AS [NO],
            CAST(CONCAT(sd_ow_account,' - ',sd_name) AS NVARCHAR(255)) AS [NAME],
            CAST(1 AS SMALLINT) AS [LEAD_TIME_DAYS],
            CASE WHEN ss.sset_do_not_use = 1 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END  AS [CLOSED]
       FROM cus.supplier_detail sd
	   INNER JOIN cus.supplier_setting ss ON ss.sset_supplier_id = sd.sd_id


