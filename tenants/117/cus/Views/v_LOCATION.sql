



-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Location mapping from raw to adi
--
--  24.09.2024.TO   Updated
-- ===============================================================================


    CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST(ISNULL([Plant],[Plant1]) AS NVARCHAR(255)) AS [NO],
            CAST([Name] AS NVARCHAR(255)) AS [NAME]
    FROM cus.plant
	WHERE [Name] <> 'Main Site'
	GROUP BY ISNULL([Plant],[Plant1]), [Name]


