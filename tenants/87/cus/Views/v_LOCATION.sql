



-- ===============================================================================
-- Author:      José Sucena
-- Description: LOCATION Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_LOCATION] 
AS

    SELECT
        CAST([Code] AS NVARCHAR(255)) AS [NO],
        CAST([Name] AS NVARCHAR(255)) AS [NAME],
        Company
    FROM
        [cus].location


