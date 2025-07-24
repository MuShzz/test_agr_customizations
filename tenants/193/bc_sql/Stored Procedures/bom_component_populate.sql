-- ===============================================================================
-- Author:      Jorundur Matthiasson
-- Create date: 27.02.2025
-- Description: Populate adi.BOM_COMPONENT
-- ===============================================================================
CREATE PROCEDURE [bc_sql_cus].[bom_component_populate]
AS
BEGIN
    SET NOCOUNT ON

    -- ###
    -- ### PART 1 : #production_bom_line   (only use latest [Version Code])
    -- ###

    DROP TABLE IF EXISTS #production_bom_line
    CREATE TABLE #production_bom_line
    (
        [Production BOM No_]   NVARCHAR(20)    NOT NULL,
        [Line No_]             INT             NOT NULL,
        [Type]                 NVARCHAR(50)    NOT NULL,
        [No_]                  NVARCHAR(20)    NOT NULL,
        [Unit of Measure Code] NVARCHAR(10)    NOT NULL,
        [Quantity per]         NUMERIC(38, 20) NOT NULL,
        PRIMARY KEY ([Production BOM No_], [Line No_])
    );
    WITH latest_versions AS (
				SELECT 
					[Production BOM No_],
					MAX([Version Code]) AS latest_version
				FROM bc_sql.ProductionBOMLine
				GROUP BY [Production BOM No_]
			),
		production_bom_line_with_version AS
             (SELECT   pbl.[Production BOM No_],
                       pbl.[Line No_],
                       CASE
                           WHEN pbl.[Type] = 0 THEN ''
                           WHEN pbl.[Type] = 1 THEN 'Item'
                           WHEN pbl.[Type] = 2 THEN 'Production BOM' END AS [Type],
                       pbl.[No_],
                       pbl.[Unit of Measure Code],
                       pbl.[Quantity per]
              FROM bc_sql.ProductionBOMLine pbl
			  INNER JOIN latest_versions v ON pbl.[Production BOM No_] = v.[Production BOM No_] AND pbl.[Version Code] = v.latest_version
			  )
    INSERT
    INTO #production_bom_line ([Production BOM No_], [Line No_], [Type], [No_], [Unit of Measure Code], [Quantity per])
    SELECT [Production BOM No_],
           [Line No_],
           [Type],
           [No_],
           [Unit of Measure Code],
           [Quantity per]
    FROM production_bom_line_with_version
    ORDER BY [Production BOM No_], [Line No_]


    -- ###
    -- ### PART 2 : #circular_bom
    -- ###

    DROP TABLE IF EXISTS #circular_bom
    CREATE TABLE #circular_bom
    (
        item_no NVARCHAR(20) NOT NULL,
        src     VARCHAR(20)  NOT NULL,
        PRIMARY KEY (item_no, src)
    )

    --
    -- Production Circular BOM
    --
    -- *** For some very strange reason it takes forever if INSERT INTO temp table
    --     SELECT works (takes 5+ minutes)
    --     INSERT to table variable works (takes 5+ minutes)
    --     why in the hell does an INSERT to a temp table or real table not work (takes forever) ???
    DECLARE @circular_bom TABLE
                          (
                              item_no NVARCHAR(20),
                              src     VARCHAR(20)
                          );
    WITH circular_production_cte_tree AS
             (
                 -- Base is all items that have recipe and not registered as Assembly BOM parent
                 SELECT item_no            = [No_],
                        [level]            = 0,
                        --bom_recipe_no      = CAST(NULL AS NVARCHAR(20)),
                        --bom_item_no        = [No_],
                        bom_component_type = CAST('Production BOM' AS NVARCHAR(50)),
                        bom_component_no   = [Production BOM No_]
                 FROM bc_sql.item
                 WHERE [Production BOM No_] != ''
                   AND [Replenishment System] = 1
                   AND [No_] NOT IN (SELECT DISTINCT c.[Parent Item No_]
                                     FROM bc_sql.BOMComponent c
                                              INNER JOIN bc_sql.Item i
                                                         ON i.[No_] = c.[Parent Item No_] AND i.[Replenishment System] = 3)
                 UNION ALL
                 -- Recursively go into recipe
                 SELECT item_no            = r.item_no,
                        [level]            = r.[level] + 1,
                        --bom_recipe_no      = l.[[Production BOM No_]],
                        --bom_item_no        = CAST(NULL AS NVARCHAR(20)),
                        bom_component_type = l.[Type],
                        bom_component_no   = l.[No_]
                 FROM circular_production_cte_tree r
                          INNER JOIN #production_bom_line l ON l.[Production BOM No_] = r.bom_component_no
                 WHERE r.bom_component_type = 'Production BOM'

                   AND r.[level] < 90
                 UNION ALL
                 -- Recursively go into item if it has recipe
                 SELECT item_no            = r.item_no,
                        [level]            = r.[level] + 1,
                        --bom_recipe_no      = CAST(NULL AS NVARCHAR(20)),
                        --bom_item_no        = i.[No_],
                        bom_component_type = 'Production BOM',
                        bom_component_no   = i.[Production BOM No_]
                 FROM circular_production_cte_tree r
                          INNER JOIN bc_sql.Item i ON i.[No_] = r.bom_component_no AND i.[Production BOM No_] != ''
                 WHERE r.bom_component_type = 'Item'
                   AND r.[level] < 90)
    INSERT
    INTO @circular_bom (item_no, src)
    SELECT DISTINCT item_no, 'production'
    FROM circular_production_cte_tree
    WHERE [level] = 90

    INSERT INTO #circular_bom (item_no, src)
    SELECT item_no, src
    FROM @circular_bom
    ORDER BY 1, 2

    --
    -- Assembly Circular BOM
    --
    ;
    WITH circular_assembly_cte_tree AS
             (SELECT DISTINCT tree_no   = [Parent Item No_],
                              recipe_no = [Parent Item No_],
                              [level]   = 0
              FROM bc_sql.BOMComponent
              UNION ALL
              SELECT tree_no   = r.tree_no,
                     recipe_no = c.[No_],
                     [level]   = r.[level] + 1
              FROM circular_assembly_cte_tree r
                       INNER JOIN bc_sql.BOMComponent c ON c.[Parent Item No_] = r.recipe_no
              WHERE r.[level] < 90)
    INSERT
    INTO #circular_bom (item_no, src)
    SELECT DISTINCT tree_no, 'assembly'
    FROM circular_assembly_cte_tree
    WHERE [level] = 90
      AND tree_no NOT IN (SELECT item_no FROM #circular_bom)


    -- ###
    -- ### PART 3 : #adi_BOM_COMPONENT
    -- ###

    DECLARE @adi_BOM_COMPONENT TABLE
                               (
                                   ITEM_NO           NVARCHAR(255)  NOT NULL,
                                   COMPONENT_ITEM_NO NVARCHAR(255)  NOT NULL,
                                   QUANTITY          DECIMAL(18, 4) NOT NULL,
                                   [source]          VARCHAR(20)    NULL
                                       PRIMARY KEY CLUSTERED (ITEM_NO, COMPONENT_ITEM_NO)
                               )

    --
    -- Production BOM
    --
    ;
    WITH production_cte_tree AS
             (
                 -- Base is all items that have recipe and not registered as Assembly BOM parent
                 SELECT item_no              = [No_],
                        [level]              = 0,
                        --bom_recipe_no        = CAST(NULL AS NVARCHAR(20)),
                        bom_component_type   = CAST('Production BOM' AS NVARCHAR(50)),
                        bom_component_no     = [Production BOM No_],
                        unit_of_measure_code = CAST(NULL AS NVARCHAR(10)),
                        quantity             = CAST(NULL AS NUMERIC(38, 20))
                 FROM bc_sql.Item
                 WHERE [Production BOM No_] != ''
                   AND [Replenishment System] = 1
                   AND [No_] NOT IN (SELECT item_no FROM #circular_bom)
                   AND [No_] NOT IN (SELECT DISTINCT c.[Parent Item No_]
                                     FROM bc_sql.BOMComponent c
                                              INNER JOIN bc_sql.Item i
                                                         ON i.[No_] = c.[Parent Item No_] AND i.[Replenishment System] = 3)
                 UNION ALL
                 -- Recursively go into recipe
                 SELECT item_no              = r.item_no,
                        [level]              = r.[level] + 1,
                        --bom_recipe_no        = l.[Production BOM No_],
                        bom_component_type   = l.[Type],
                        bom_component_no     = l.[No_],
                        unit_of_measure_code = l.[Unit of Measure Code],
                        quantity             = l.[Quantity per]
                 FROM production_cte_tree r
                          INNER JOIN bc_sql.Item i ON i.[No_] = r.item_no
                          INNER JOIN #production_bom_line l ON l.[Production BOM No_] = r.bom_component_no
                 WHERE i.[Replenishment System] = 1
                   AND r.bom_component_type = 'Production BOM'
                   AND l.[Production BOM No_] NOT IN (SELECT item_no FROM #circular_bom)),
         --
         -- Assembly BOM
         --
         assembly_cte_tree AS
             (SELECT DISTINCT bom_no  = CAST(NULL AS NVARCHAR(20)),
                              [No_]   = c.[Parent Item No_],
                              qty     = CAST(0 AS NUMERIC(38, 20)),
                              [level] = 0
              FROM bc_sql.BOMComponent c
                       INNER JOIN bc_sql.Item i ON i.[No_] = c.[Parent Item No_]
              WHERE i.[Replenishment System] = 3
                AND c.[No_] NOT IN (SELECT item_no FROM #circular_bom)

              UNION ALL

              SELECT bom_no  = CAST(c.[Parent Item No_] AS NVARCHAR(20)),
                     [No_]   = c.[No_],
                     qty     = CAST(c.[Quantity per] AS NUMERIC(38, 20)),
                     [level] = r.[level] + 1
              FROM assembly_cte_tree r
                       INNER JOIN bc_sql.BOMComponent c ON c.[Parent Item No_] = r.[No_]
                       INNER JOIN bc_sql.Item i ON i.[No_] = c.[Parent Item No_]
              WHERE i.[Replenishment System] = 3
                AND c.[No_] NOT IN (SELECT item_no FROM #circular_bom)),
         assembly_cte_top_level_removed AS
             (SELECT bom_no,
                     [No_],
                     qty,
                     rn = ROW_NUMBER() OVER (PARTITION BY bom_no, [No_] ORDER BY [level])
              FROM assembly_cte_tree
              WHERE [level] > 0)
    --
    -- Production + Assembly BOM
    --
    INSERT
    INTO @adi_BOM_COMPONENT (ITEM_NO, COMPONENT_ITEM_NO, QUANTITY, [source])
    SELECT ITEM_NO           = CAST(x.item_no AS NVARCHAR(255)),
           COMPONENT_ITEM_NO = CAST(x.bom_component_no AS NVARCHAR(255)),
           QUANTITY          = CAST(SUM(x.quantity * ISNULL(u.[Qty_ per Unit of Measure], 1.0)) AS DECIMAL(18, 4)),
           [source]          = 'production'
    FROM production_cte_tree x
             LEFT JOIN bc_sql.ItemUnitofMeasure u
                       ON u.[Item No_] = x.bom_component_no AND u.Code = x.unit_of_measure_code
    WHERE x.bom_component_type = 'Item'
    GROUP BY x.item_no, x.bom_component_no
    UNION ALL
    SELECT ITEM_NO           = CAST(bom_no AS NVARCHAR(255)),
           COMPONENT_ITEM_NO = CAST([No_] AS NVARCHAR(255)),
           QUANTITY          = CAST(qty AS DECIMAL(18, 4)),
           [source]          = 'assembly'
    FROM assembly_cte_top_level_removed
    WHERE rn = 1

    --select [source], count(*) from @adi_BOM_COMPONENT group by [source]
--select top 10 * from @adi_BOM_COMPONENT

    TRUNCATE TABLE bc_sql_cus.prep_BOM_COMPONENT
    INSERT INTO bc_sql_cus.prep_BOM_COMPONENT (ITEM_NO, COMPONENT_ITEM_NO, QUANTITY)
    SELECT ITEM_NO, COMPONENT_ITEM_NO, QUANTITY
    FROM @adi_BOM_COMPONENT
    ORDER BY 1, 2;

    select 1

END

