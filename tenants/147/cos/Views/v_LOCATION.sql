




-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_LOCATION]
AS

    SELECT
        CAST([NO] AS NVARCHAR(255))     AS [NO],
        CAST([NAME] AS NVARCHAR(255))   AS [NAME]
    FROM
        [cos].[AGR_LOCATION]
	WHERE [NO] NOT LIKE 'H1%'
	AND [NO] NOT LIKE 'H2%'
	AND [NO] NOT LIKE 'H3%'
	AND [NO] NOT LIKE 'H4%'
	AND [NO] NOT LIKE 'H5%'
	AND [NO] NOT LIKE 'H7%'
	AND [NO] NOT LIKE 'HA%'
	AND [NO] NOT LIKE 'HB%'

