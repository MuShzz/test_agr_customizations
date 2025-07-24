
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Location mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_LOCATION]
AS

        SELECT
            CAST([Code] AS NVARCHAR(255)) AS [NO],
            CAST([Name] AS NVARCHAR(255)) AS [NAME]
        FROM
            [bc_rest].location

		UNION ALL

		SELECT
            CAST('VARAHLUTIR' AS NVARCHAR(255)) AS [NO],
            CAST('VARAHLUTIR' AS NVARCHAR(255)) AS [NAME]

