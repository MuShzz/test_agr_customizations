




-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

    CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST(OWHS.[WhsCode] AS NVARCHAR(255)) AS [NO],
            CAST(OWHS.[WhsName] AS NVARCHAR(255)) AS [NAME]
        FROM cus.OWHS
			WHERE OWHS.WhsCode IN ('GEN','NB','NBL','NR','NRL','SPECIALS','WB', 'NSW', 'CST', 'Z-CST')


