

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Item group mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================

CREATE   VIEW [bc_rest_cus].[v_ITEM_GROUP]
AS

    SELECT
        CAST([Code] AS NVARCHAR(255)) AS [NO],
        CAST([Description] AS NVARCHAR(255)) AS [NAME]
    FROM
        [bc_rest].item_category

	UNION ALL

	SELECT DISTINCT
        CAST([Description] AS NVARCHAR(255)) AS [NO],
        CAST([Description] AS NVARCHAR(255)) AS [NAME]
    FROM
        [bc_rest_cus].[ProductGroup]


