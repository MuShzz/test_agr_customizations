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
        item_no  NVARCHAR(255)  NOT NULL,
        src      VARCHAR(20)    NOT NULL,
        PRIMARY KEY (item_no, src)
    )

    --
    -- Assembly Circular BOM
    --
    ;WITH circular_assembly_cte_tree AS
              (
                  SELECT DISTINCT
                      tree_no   = CAST(ParentItemNo + CASE WHEN VariantCode IS NULL OR VariantCode = '' THEN '' ELSE '-' + VariantCode END AS NVARCHAR(255)),
                      recipe_no = CAST(ParentItemNo + CASE WHEN VariantCode IS NULL OR VariantCode = '' THEN '' ELSE '-' + VariantCode END AS NVARCHAR(255)),
                      [level]   = 0
                  FROM
                      bc_rest.bom_component
                  UNION ALL
                  SELECT
                      tree_no   = r.tree_no,
                      recipe_no = CAST(c.[No] + CASE WHEN c.VariantCode IS NULL OR c.VariantCode = '' THEN '' ELSE '-' + c.VariantCode END AS NVARCHAR(255)),
                      [level]   = r.[level] + 1
                  FROM
                      circular_assembly_cte_tree r
                          INNER JOIN bc_rest.bom_component c ON CAST(c.ParentItemNo + CASE WHEN c.VariantCode IS NULL OR c.VariantCode = '' THEN '' ELSE '-' + c.VariantCode END AS NVARCHAR(255)) = r.recipe_no
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

                  select item_no              = l.ProductionBOMNo,
                         [level]              = 1,
                         bom_component_type   = l.[Type],
                         bom_component_no     = l.[No],
                         unit_of_measure_code = l.UnitofMeasureCode,
                         quantity             = l.Quantityper
                  from bc_rest.production_bom_line l
                           inner join bc_rest.item i on l.ProductionBOMNo = i.No
                  where i.ReplenishmentSystem = 'Prod. Order'
              ),
          --
          -- Assembly BOM
          --
          assembly_cte_tree AS
              (
                  SELECT DISTINCT
                      bom_no  = CAST(NULL AS NVARCHAR(255)),
                      [no]    = CAST(c.ParentItemNo + CASE WHEN c.VariantCode IS NULL OR c.VariantCode = '' THEN '' ELSE '-' + c.VariantCode END AS NVARCHAR(255)),
                      qty     = CAST(0 AS NUMERIC(38, 20)),
                      [level] = 0
                  FROM
                      bc_rest.bom_component c
                          INNER JOIN bc_rest.item i ON i.[No] = c.ParentItemNo
                  WHERE
                      i.ReplenishmentSystem = 'Assembly'
                    AND CAST(c.[No] + CASE WHEN c.VariantCode IS NULL OR c.VariantCode = '' THEN '' ELSE '-' + c.VariantCode END AS NVARCHAR(255)) NOT IN (SELECT item_no FROM #circular_bom)
                  UNION ALL
                  SELECT
                      bom_no  = CAST(c.ParentItemNo + CASE WHEN c.VariantCode IS NULL OR c.VariantCode = '' THEN '' ELSE '-' + c.VariantCode END AS NVARCHAR(255)),
                      [no]    = CAST(c.[No] + CASE WHEN c.VariantCode IS NULL OR c.VariantCode = '' THEN '' ELSE '-' + c.VariantCode END AS NVARCHAR(255)),
                      qty     = CAST(c.Quantityper AS NUMERIC(38,20)),
                      [level] = r.[level] + 1
                  FROM
                      assembly_cte_tree r
                          INNER JOIN bc_rest.bom_component c ON CAST(c.ParentItemNo + CASE WHEN c.VariantCode IS NULL OR c.VariantCode = '' THEN '' ELSE '-' + c.VariantCode END AS NVARCHAR(255)) = r.[no]
                  WHERE
                      CAST(c.[No] + CASE WHEN c.VariantCode IS NULL OR c.VariantCode = '' THEN '' ELSE '-' + c.VariantCode END AS NVARCHAR(255)) NOT IN (SELECT item_no FROM #circular_bom)
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
             LEFT JOIN bc_rest.item_unit_of_measure u ON u.ItemNo = CASE
                                                                        WHEN CHARINDEX('-', x.bom_component_no) > 0
                                                                            THEN LEFT(x.bom_component_no, CHARINDEX('-', x.bom_component_no) - 1)
                                                                        ELSE x.bom_component_no
             END AND u.Code = x.unit_of_measure_code
     --WHERE x.bom_component_type = 'Item'
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
    SELECT ITEM_NO, COMPONENT_ITEM_NO, QUANTITY FROM @adi_BOM_COMPONENT ORDER BY 1, 2;

    select 1

END
