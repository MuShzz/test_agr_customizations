-- ===============================================================================
-- Author:      Jorundur Matthiasson
-- Create date: 27.02.2025
-- Description: Populate adi.BOM_COMPONENT
-- ===============================================================================
CREATE PROCEDURE [bc_rest_cus].[bom_component_populate]
AS
BEGIN
    SET NOCOUNT ON

    -- ###
    -- ### PART 1 : #production_bom_line   (only use latest VersionCode)
    -- ###

    DROP TABLE IF EXISTS #production_bom_line
    CREATE TABLE #production_bom_line
    (
        ProductionBOMNo    NVARCHAR(20)    NOT NULL,
        [LineNo]           INT             NOT NULL,
        [Type]             NVARCHAR(50)    NOT NULL,
        [No]               NVARCHAR(20)    NOT NULL,
        UnitofMeasureCode  NVARCHAR(10)    NOT NULL,
        Quantityper        NUMERIC(38,20)  NOT NULL,
        PRIMARY KEY (ProductionBOMNo, [LineNo])
    )

    ;WITH production_bom_line_with_rn AS
              (
                  SELECT
                      ProductionBOMNo, [LineNo], [Type], [No], UnitofMeasureCode, Quantityper,
                      rn = ROW_NUMBER() OVER (PARTITION BY ProductionBomNo, [LineNo] ORDER BY VersionCode DESC)
                  FROM
                      bc_rest.production_bom_line
              )
     INSERT INTO #production_bom_line (ProductionBOMNo, [LineNo], [Type], [No], UnitofMeasureCode, Quantityper)
     SELECT
         ProductionBOMNo, [LineNo], [Type], [No], UnitofMeasureCode, Quantityper
     FROM
         production_bom_line_with_rn
     WHERE
         rn = 1
     ORDER BY
         ProductionBOMNo, [LineNo]


    -- ###
    -- ### PART 2 : #circular_bom
    -- ###

    DROP TABLE IF EXISTS #circular_bom
    CREATE TABLE #circular_bom
    (
        item_no  NVARCHAR(20)  NOT NULL,
        src      VARCHAR(20)   NOT NULL,
        PRIMARY KEY (item_no, src)
    )

    --
    -- Production Circular BOM
    --
    -- *** For some very strange reason it takes forever if INSERT INTO temp table
    --     SELECT works (takes 5+ minutes)
    --     INSERT to table variable works (takes 5+ minutes)
    --     why in the hell does an INSERT to a temp table or real table not work (takes forever) ???
    DECLARE @circular_bom TABLE (item_no NVARCHAR(20), src VARCHAR(20))

    ;WITH circular_production_cte_tree AS
              (
                  -- Base is all items that have recipe and not registered as Assembly BOM parent
                  SELECT
                      item_no            = [No],
                      [level]            = 0,
                      --bom_recipe_no      = CAST(NULL AS NVARCHAR(20)),
                      --bom_item_no        = [No],
                      bom_component_type = CAST('Production BOM' AS NVARCHAR(50)),
                      bom_component_no   = ProductionBOMNo
                  FROM
                      bc_rest.item
                  WHERE
                      ProductionBOMNo != '' AND ReplenishmentSystem = 'Prod. Order'
                    AND [No] NOT IN (SELECT DISTINCT c.ParentItemNo
                                     FROM bc_rest.bom_component c
                                              INNER JOIN bc_rest.item i ON i.[No] = c.ParentItemNo AND i.ReplenishmentSystem = 'Assembly')
                  UNION ALL
                  -- Recursively go into recipe
                  SELECT
                      item_no            = r.item_no,
                      [level]            = r.[level] + 1,
                      --bom_recipe_no      = l.[ProductionBOMNo],
                      --bom_item_no        = CAST(NULL AS NVARCHAR(20)),
                      bom_component_type = l.[Type],
                      bom_component_no   = l.[No]
                  FROM
                      circular_production_cte_tree r
                          INNER JOIN #production_bom_line l ON l.ProductionBOMNo = r.bom_component_no
                  WHERE
                      r.bom_component_type = 'Production BOM' AND r.[level] < 90
                  UNION ALL
                  -- Recursively go into item if it has recipe
                  SELECT
                      item_no            = r.item_no,
                      [level]            = r.[level] + 1,
                      --bom_recipe_no      = CAST(NULL AS NVARCHAR(20)),
                      --bom_item_no        = i.[No],
                      bom_component_type = 'Production BOM',
                      bom_component_no   = i.ProductionBOMNo
                  FROM
                      circular_production_cte_tree r
                          INNER JOIN bc_rest.item i ON i.[No] = r.bom_component_no AND i.ProductionBOMNo != ''
                  WHERE
                      r.bom_component_type = 'Item' AND r.[level] < 90
              )
     INSERT INTO @circular_bom (item_no, src)
     SELECT DISTINCT item_no, 'production' FROM circular_production_cte_tree WHERE [level] = 90

    INSERT INTO #circular_bom (item_no, src)
    SELECT item_no, src FROM @circular_bom ORDER BY 1, 2

    --
    -- Assembly Circular BOM
    --
    ;WITH circular_assembly_cte_tree AS
              (
                  SELECT DISTINCT
                      tree_no   = ParentItemNo,
                      recipe_no = ParentItemNo,
                      [level]   = 0
                  FROM
                      bc_rest.bom_component
                  UNION ALL
                  SELECT
                      tree_no   = r.tree_no,
                      recipe_no = c.[No],
                      [level]   = r.[level] + 1
                  FROM
                      circular_assembly_cte_tree r
                          INNER JOIN bc_rest.bom_component c ON c.ParentItemNo = r.recipe_no
                  WHERE
                      r.[level] < 90
              )
     INSERT INTO #circular_bom (item_no, src)
     SELECT DISTINCT tree_no, 'assembly'
     FROM circular_assembly_cte_tree
     WHERE [level] = 90 AND tree_no NOT IN (SELECT item_no FROM #circular_bom)


    -- ###
    -- ### PART 3 : #adi_BOM_COMPONENT
    -- ###

    DECLARE @adi_BOM_COMPONENT TABLE
                               (
                                   ITEM_NO            NVARCHAR(255)  NOT NULL,
                                   COMPONENT_ITEM_NO  NVARCHAR(255)  NOT NULL,
                                   QUANTITY           DECIMAL(18,4)  NOT NULL,
                                   [source]           VARCHAR(20)    NULL
                                       PRIMARY KEY CLUSTERED (ITEM_NO, COMPONENT_ITEM_NO)
                               )

    --
    -- Production BOM
    --
    ;WITH production_cte_tree AS
              (
                  -- Base is all items that have recipe and not registered as Assembly BOM parent
                  SELECT
                      item_no              = [No],
                      [level]              = 0,
                      --bom_recipe_no        = CAST(NULL AS NVARCHAR(20)),
                      bom_component_type   = CAST('Production BOM' AS NVARCHAR(50)),
                      bom_component_no     = ProductionBOMNo,
                      unit_of_measure_code = CAST(NULL AS NVARCHAR(10)),
                      quantity             = CAST(NULL AS NUMERIC(38, 20))
                  FROM
                      bc_rest.item
                  WHERE
                      ProductionBOMNo != '' AND ReplenishmentSystem = 'Prod. Order'
                    AND [No] NOT IN (SELECT item_no FROM #circular_bom)
                    AND [No] NOT IN (SELECT DISTINCT c.ParentItemNo
                                     FROM bc_rest.bom_component c
                                              INNER JOIN bc_rest.item i ON i.[No] = c.ParentItemNo AND i.ReplenishmentSystem = 'Assembly')
                  UNION ALL
                  -- Recursively go into recipe
                  SELECT
                      item_no              = r.item_no,
                      [level]              = r.[level] + 1,
                      --bom_recipe_no        = l.ProductionBOMNo,
                      bom_component_type   = l.[Type],
                      bom_component_no     = l.[No],
                      unit_of_measure_code = l.UnitofMeasureCode,
                      quantity             = l.Quantityper
                  FROM
                      production_cte_tree r
                          INNER JOIN #production_bom_line l ON l.ProductionBOMNo = r.bom_component_no
                  WHERE
                      r.bom_component_type = 'Production BOM'
                    AND l.ProductionBOMNo NOT IN (SELECT item_no FROM #circular_bom)
              ),
          --
          -- Assembly BOM
          --
          assembly_cte_tree AS
              (
                  SELECT DISTINCT
                      bom_no  = CAST(NULL AS NVARCHAR(20)),
                      [no]    = c.ParentItemNo,
                      qty     = CAST(0 AS NUMERIC(38, 20)),
                      [level] = 0
                  FROM
                      bc_rest.bom_component c
                          INNER JOIN bc_rest.item i ON i.[No] = c.ParentItemNo
                  WHERE
                      i.ReplenishmentSystem = 'Assembly'
                    AND c.[No] NOT IN (SELECT item_no FROM #circular_bom)
                  UNION ALL
                  SELECT
                      bom_no  = CAST(c.ParentItemNo AS NVARCHAR(20)),
                      [no]    = c.[No],
                      qty     = CAST(c.Quantityper AS NUMERIC(38,20)),
                      [level] = r.[level] + 1
                  FROM
                      assembly_cte_tree r
                          INNER JOIN bc_rest.bom_component c ON c.ParentItemNo = r.[no]
                  WHERE
                      c.[No] NOT IN (SELECT item_no FROM #circular_bom)
              ),
          assembly_cte_top_level_removed AS
              (
                  SELECT
                      bom_no,
                      [no],
                      qty,
                      rn = ROW_NUMBER() OVER (PARTITION BY bom_no, [no] ORDER BY [level])
                  FROM
                      assembly_cte_tree
                  WHERE
                      [level] > 0
              )
     --
     -- Production + Assembly BOM
     --
     INSERT INTO @adi_BOM_COMPONENT (ITEM_NO, COMPONENT_ITEM_NO, QUANTITY, [source])
     SELECT
         ITEM_NO           = CAST(x.item_no AS NVARCHAR(255)),
         COMPONENT_ITEM_NO = CAST(x.bom_component_no AS NVARCHAR(255)),
         QUANTITY          = CAST(SUM(x.quantity * ISNULL(u.QtyperUnitofMeasure, 1.0)) AS DECIMAL(18, 4)),
         [source]          = 'production'
     FROM
         production_cte_tree x
             LEFT JOIN bc_rest.item_unit_of_measure u ON u.ItemNo = x.bom_component_no AND u.Code = x.unit_of_measure_code
     WHERE
         x.bom_component_type = 'Item'
     GROUP BY
         x.item_no, x.bom_component_no
     UNION ALL
     SELECT
         ITEM_NO           = CAST(bom_no AS NVARCHAR(255)),
         COMPONENT_ITEM_NO = CAST([no] AS NVARCHAR(255)),
         QUANTITY          = CAST(qty AS DECIMAL(18, 4)),
         [source]          = 'assembly'
     FROM
         assembly_cte_top_level_removed
     WHERE
         rn = 1

    --select [source], count(*) from @adi_BOM_COMPONENT group by [source]
--select top 10 * from @adi_BOM_COMPONENT

    TRUNCATE TABLE bc_rest_cus.prep_BOM_COMPONENT
    INSERT INTO bc_rest_cus.prep_BOM_COMPONENT (ITEM_NO, COMPONENT_ITEM_NO, QUANTITY)
    SELECT CAST(bc.ITEM_NO + CASE WHEN iv.Code IS NULL OR iv.Code = '' THEN '' ELSE '-' + iv.Code END AS NVARCHAR(255)) as ITEM_NO,
           CAST(bc.COMPONENT_ITEM_NO + CASE WHEN cv.Code IS NULL OR cv.Code = '' THEN '' ELSE '-' + cv.Code END AS NVARCHAR(255)) as COMPONENT_ITEM_NO,
           bc.QUANTITY
    FROM @adi_BOM_COMPONENT bc
             LEFT JOIN [bc_rest].item_variant iv
                       ON bc.ITEM_NO = iv.ItemNo
             LEFT JOIN [bc_rest].item_variant cv
                       ON bc.COMPONENT_ITEM_NO= cv.ItemNo
                           AND iv.Code = cv.Code
    ORDER BY 1, 2;

    select 1

END
