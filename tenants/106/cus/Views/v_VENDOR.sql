


-- ===============================================================================
-- Author:      Jose, Jose e Paulo
-- Description: Vendor mapping from erp to raw forma, Sage 200
--
--  20.09.2024.TO   Created
-- ===============================================================================

    CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST(sd_id AS NVARCHAR(255)) AS [NO],
            CAST(sd_name AS NVARCHAR(255)) AS [NAME],
            CAST(0 AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(sset_do_not_use AS BIT) AS [CLOSED]
       FROM cus.Vendor


