



-- ===============================================================================
-- Author:      José Sucena
-- Description: VENDOR mapping from cus
--
--  24.09.2024.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_VENDOR] 
AS
       SELECT
            CAST(TRIM([ACCOUNT]) AS NVARCHAR(255)) AS [NO],
            CAST([NAME] AS NVARCHAR(255)) AS [NAME],
            CAST(LEADTIME AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST([BLOCKED] AS BIT) AS [CLOSED]
       FROM [cus].[VENDTABLE]
       WHERE [DATASET] = 'DAT'
   


