
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: BOM mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_BOM_COMPONENT]
AS

-- DUMMY BOM for testing purposes 
		WITH cte AS (
		SELECT bc1_ItemHeaderID+bc1_ItemVariant1ID AS ITEM_NO, SUM(-ile.Quantity) AS TOTAL_SALE FROM bc_rest_cus.item_extra_info iei
		INNER JOIN bc_rest.item_ledger_entry ile ON ile.ItemNo = iei.No
		WHERE iei.NO LIKE 'B01000159403%'
		AND  CAST(ile.[PostingDate] AS DATE) > DATEADD(DD,-365,GETDATE()) 
		GROUP BY bc1_ItemHeaderID+bc1_ItemVariant1ID
		) 		
		,cte2 AS (
		SELECT ile.ItemNo AS COMPONENT_ITEM_NO, bc1_ItemHeaderID+bc1_ItemVariant1ID AS ITEM_NO, SUM(-ile.Quantity) AS ITEM_SALE FROM bc_rest_cus.item_extra_info iei
		INNER JOIN bc_rest.item_ledger_entry ile ON ile.ItemNo = iei.No
		WHERE iei.NO LIKE 'B01000159403%'
		AND  CAST(ile.[PostingDate] AS DATE) > DATEADD(DD,-365,GETDATE()) 
		GROUP BY ile.ItemNo, bc1_ItemHeaderID+bc1_ItemVariant1ID
		)		
		SELECT cte.ITEM_NO, COMPONENT_ITEM_NO, ITEM_SALE/TOTAL_SALE AS QUANTITY, 'Size distribution' AS [source]  FROM cte 
		INNER JOIN cte2 ON cte2.ITEM_NO = cte.ITEM_NO	                  
		                  

/*

    -- These are recursive CTEs, beware

    --------------------
    -- Production BOM --
    --------------------
		WITH circularProductionBOM_rest AS
        (
            SELECT [No], [ProductionBOMNo], /*CAST([No] AS NVARCHAR(MAX)) AS path,*/ 0 AS distance
            FROM bc_rest.production_bom_line
        
            UNION ALL
        
            SELECT c.[No], p.[ProductionBOMNo], /*c.path + N' > ' + CAST(p.[No] AS NVARCHAR(MAX)),*/ c.distance + 1
            FROM bc_rest.production_bom_line p
                JOIN circularProductionBOM_rest c ON c.[ProductionBOMNo] = p.[No] AND p.[ProductionBOMNo] <> p.[No] AND c.[ProductionBOMNo] <> c.[No]
            WHERE c.distance < 10
        ), circularAssemblyBOM_rest AS (
            SELECT [No], [ParentItemNo], /*CAST([No] AS NVARCHAR(MAX)) AS path,*/ 0 AS distance
            FROM bc_rest.bom_component
    
            UNION ALL
    
            SELECT c.[No], p.[ParentItemNo], /*c.path + N' > ' + CAST(p.[No] AS NVARCHAR(MAX)),*/ c.distance + 1
            FROM bc_rest.bom_component p
                JOIN circularAssemblyBOM_rest c ON c.[ParentItemNo] = p.[No] AND p.[ParentItemNo] <> p.[No] AND c.[ParentItemNo] <> c.[No]
            WHERE c.distance < 10
        ), circular_bom_t AS
		(
            SELECT DISTINCT [No] AS item_no, 'production' AS src
            FROM circularProductionBOM_rest
            WHERE [No] = [ProductionBOMNo] 
                AND distance > 0
            UNION ALL
            SELECT DISTINCT [No] AS item_no, 'assembly' AS src
            FROM circularAssemblyBOM_rest
            WHERE [No] = [ParentItemNo] 
                AND distance > 0
		), circular_bom AS
		(	SELECT item_no, src
			FROM circular_bom_t
			UNION
            SELECT DISTINCT [No] AS item_no, 'production' AS src
            FROM bc_rest.production_bom_line
            WHERE [No] = [ProductionBOMNo] 
                AND [No] NOT IN (SELECT item_no COLLATE DATABASE_DEFAULT FROM circular_bom_t)
            UNION
            SELECT DISTINCT [No] AS item_no, 'assembly' AS src
            FROM bc_rest.bom_component
            WHERE [No] = [ParentItemNo] 
                AND [No] NOT IN (SELECT item_no COLLATE DATABASE_DEFAULT FROM circular_bom_t)
		),
		agg_bom_line AS (
        SELECT [ProductionBOMNo], No, SUM(Quantity) AS Quantity, MAX([UnitofMeasureCode]) AS [UnitofMeasureCode] FROM bc_rest.production_bom_line WHERE [VersionCode] = '' AND Type = 'Item' GROUP BY [ProductionBOMNo], No
    ),
    production_cte_tree AS (
        SELECT CAST(NULL AS NVARCHAR(20)) AS bom_no, CAST(NULL AS NVARCHAR(20)) AS header_no, bh.[No] AS no, /*CAST([No] AS NVARCHAR(MAX)) AS trace,*/ CAST(0.0 AS NUMERIC(38,20)) AS qty, 0 AS level
        FROM bc_rest.production_bom_header bh JOIN bc_rest.item i ON i.[ProductionBOMNo] = bh.No
        -- Status 1 = Certified, Replenishment System 1 = Production Order
        WHERE i.[ReplenishmentSystem] = 'Prod. Order' AND bh.Status = 'Certified' AND bh.[VersionNos] = ''
            AND bh.No NOT IN (SELECT item_no FROM circular_bom)
            AND bh.No NOT IN (SELECT DISTINCT [ParentItemNo] FROM bc_rest.bom_component)
    
        UNION ALL
    
        SELECT l.[ProductionBOMNo] AS bom_no, i_prod.No AS header_no, l.[No] AS no, /*CAST(CONCAT(st.trace, '->', l.[No_]) AS NVARCHAR(MAX)) AS trace,*/ CAST(l.[Quantity]*iuom_comp.[QtyperUnitofMeasure]/iuom_prod.[QtyperUnitofMeasure] AS NUMERIC(38,20)) AS qty,  st.level + 1--,bh.[Low-Level Code] 
        FROM production_cte_tree st 
		    JOIN agg_bom_line l ON st.no = l.[ProductionBOMNo]
		    JOIN bc_rest.production_bom_header bh ON bh.No = l.[ProductionBOMNo] 
		    JOIN bc_rest.item i_prod ON i_prod.[ProductionBOMNo] = bh.No
		    JOIN bc_rest.item i_comp ON i_comp.No = l.No
		    JOIN bc_rest.item_unit_of_measure iuom_prod ON iuom_prod.[ItemNo] = i_prod.No AND iuom_prod.Code = bh.[UnitofMeasureCode]
		    JOIN bc_rest.item_unit_of_measure iuom_comp ON iuom_comp.[ItemNo] = i_comp.No AND iuom_comp.Code = l.[UnitofMeasureCode]
        WHERE l.No NOT IN (SELECT item_no FROM circular_bom)
    ),
    production_cte_top_level_removed AS (
        SELECT bom_no, header_no, no, qty, /*trace,*/ ROW_NUMBER() OVER (PARTITION BY bom_no, no ORDER BY level) AS rn FROM production_cte_tree WHERE production_cte_tree.level > 0
    ), 
    ------------------
    -- Assembly BOM --
    ------------------
    assembly_cte_tree AS (
        SELECT DISTINCT CAST(NULL AS NVARCHAR(20)) AS bom_no, bc.[ParentItemNo] AS no, /*CAST([ParentItemNo] AS NVARCHAR(MAX)) AS trace,*/ CAST(0.0 AS NUMERIC(38,20)) AS qty, 0 AS level
        FROM bc_rest.bom_component bc JOIN bc_rest.item i ON i.No = bc.[ParentItemNo]
        -- Status 1 = Certified, Replenishment System 1 = Production Order
        WHERE i.[ReplenishmentSystem] = 'Assembly'
            AND bc.[No] NOT IN (SELECT item_no FROM circular_bom)
    
        UNION ALL
    
        SELECT CAST(l.[ParentItemNo] AS NVARCHAR(20)) AS bom_no, l.[No] AS no, /*CAST(CONCAT(st.trace, '->', l.[No]) AS NVARCHAR(MAX)) AS trace,*/ CAST(l.[Quantityper] AS NUMERIC(38,20)),  st.level + 1
        FROM assembly_cte_tree st JOIN bc_rest.bom_component l ON st.no = l.[ParentItemNo]
        WHERE l.No NOT IN (SELECT item_no FROM circular_bom)
    ),
    assembly_cte_top_level_removed AS (
        SELECT bom_no, no, qty, /*trace,*/ ROW_NUMBER() OVER (PARTITION BY bom_no, no ORDER BY level) AS rn FROM assembly_cte_tree WHERE assembly_cte_tree.level > 0
    )
    SELECT
        CAST(header_no AS NVARCHAR(255)) AS ITEM_NO,
        CAST(no AS NVARCHAR(255))        AS COMPONENT_ITEM_NO,
        CAST(qty AS DECIMAL(18,4))       AS QUANTITY
        -- if you are having problems with this query you can copy this query to a new windows and uncomment the trace column
        --,trace
        , 'Production BOM' AS [source]
    FROM
        production_cte_top_level_removed
    WHERE
        rn = 1

    UNION ALL

    SELECT
        CAST(bom_no AS NVARCHAR(255)) AS ITEM_NO,
        CAST(no AS NVARCHAR(255))     AS COMPONENT_ITEM_NO,
        CAST(qty AS DECIMAL(18,4))    AS QUANTITY
        -- if you are having problems with this query you can copy this query to a new windows and uncomment the trace column
        --,trace
        , 'Assembly BOM' AS [source]
    FROM
        assembly_cte_top_level_removed
    WHERE
        rn = 1


*/


