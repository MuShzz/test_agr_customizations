


CREATE VIEW [nav2017_cus].[v_ITEM_GROUP] AS
     --SELECT
     --     CAST([Code] AS NVARCHAR(255)) AS [NO],
     --     CAST([Description] AS NVARCHAR(255)) AS [NAME]
     --FROM
     --     [nav2017].ItemCategory


    --27.06.2025.DFS - NAV mapping from old 6.3 plus

    WITH cte  AS (
    SELECT
        CAST([Code] AS NVARCHAR(255)) AS [NO],
        CAST([Description] AS NVARCHAR(255)) AS [NAME]
    FROM
        nav2017_cus.ItemCategory 
    

    UNION ALL

    SELECT
        nav.ProductGroupCode([Item Category Code], [Code]) AS [NO],
        nav.ProductGroupDescription([Item Category Code], [Code], [Description]) AS [NAME]
    FROM
        nav2017_cus.ProductGroup
    WHERE [Code] <> 'S92' 
		)

		SELECT 
			[NO],
			[NAME] + ' (' + [NO] +')'  AS name
		FROM cte

