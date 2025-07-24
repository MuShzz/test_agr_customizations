

-- ===============================================================================
-- Author:      José Santos
-- Description: Customer mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

    CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST(WhsCode AS NVARCHAR(255)) AS [NO],
            CAST(WhsName AS NVARCHAR(255)) AS [NAME]
       FROM
            [cus].OWHS


