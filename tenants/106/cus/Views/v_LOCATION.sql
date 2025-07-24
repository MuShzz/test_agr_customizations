

-- ===============================================================================
-- Author:      Jose, Jose e Paulo
-- Description: Location mapping 
--
--  20.09.2024.TO   Created
-- ===============================================================================


    CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST(sl_id AS NVARCHAR(255)) AS [NO],
            CAST(sl_name AS NVARCHAR(255)) AS [NAME]
       FROM cus.Location
   WHERE sl_id IN (1,2,3,9)


