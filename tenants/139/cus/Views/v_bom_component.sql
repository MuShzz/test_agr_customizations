
/****** Object:  View [cus_adi].[v_bom_component]    Script Date: 10/23/2024 4:33:28 PM ******/

-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Data mapping from CUS
--
--  12.03.2023.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_bom_component] AS
	
	-- These are recursive CTEs, beware

    --------------------
    -- Production BOM --
    --------------------
    WITH agg_bom_line AS (
        SELECT [ProductionBOMNo], No, 
               SUM(Quantity) AS Quantity, 
               MAX([UnitofMeasureCode]) AS [UnitofMeasureCode],
               Company
          FROM [cus].production_bom_line WHERE [VersionCode] = '' AND Type = 'Item' GROUP BY [ProductionBOMNo], No, Company
    ),
    production_cte_tree AS (
        SELECT CAST(NULL AS NVARCHAR(20)) AS bom_no, 
               CAST(NULL AS NVARCHAR(20)) AS header_no, 
               bh.[No] AS no, 
               /*CAST([No] AS NVARCHAR(MAX)) AS trace,*/ 
               CAST(0.0 AS NUMERIC(38,20)) AS qty, 
               0 AS level,
               bh.Company 
        FROM [cus].production_bom_header bh 
        JOIN [cus].item i ON i.[ProductionBOMNo] = bh.No AND bh.Company = i.Company
        -- Status 1 = Certified, Replenishment System 1 = Production Order
        WHERE i.[ReplenishmentSystem] = 'Prod. Order' AND bh.Status = 'Certified' AND bh.[VersionNos] = ''
            AND bh.No NOT IN (SELECT DISTINCT [ParentItemNo] FROM [cus].bom_component)
    
        UNION ALL
    
        SELECT l.[ProductionBOMNo] AS bom_no, 
               i_prod.No AS header_no, 
               l.[No] AS no, 
               /*CAST(CONCAT(st.trace, '->', l.[No_]) AS NVARCHAR(MAX)) AS trace,*/ 
               CAST(l.[Quantity]*iuom_comp.[QtyperUnitofMeasure]/iuom_prod.[QtyperUnitofMeasure] AS NUMERIC(38,20)) AS qty,  
               st.level + 1 AS level,
               bh.Company
               --,bh.[Low-Level Code] 
        FROM production_cte_tree st 
		    JOIN agg_bom_line l ON st.no = l.[ProductionBOMNo] AND st.Company = l.Company
		    JOIN [cus].production_bom_header bh ON bh.No = l.[ProductionBOMNo] AND st.Company = bh.Company
		    JOIN [cus].item i_prod ON i_prod.[ProductionBOMNo] = bh.No AND st.Company = i_prod.Company
		    JOIN [cus].item i_comp ON i_comp.No = l.No AND st.Company = i_comp.Company
		    JOIN [cus].item_unit_of_measure iuom_prod ON iuom_prod.[ItemNo] = i_prod.No AND iuom_prod.Code = bh.[UnitofMeasureCode] AND st.Company = iuom_prod.Company
		    JOIN [cus].item_unit_of_measure iuom_comp ON iuom_comp.[ItemNo] = i_comp.No AND iuom_comp.Code = l.[UnitofMeasureCode] AND st.Company = iuom_comp.Company
    ),
    production_cte_top_level_removed AS (
        SELECT bom_no, header_no, no, qty, /*trace,*/ ROW_NUMBER() OVER (PARTITION BY bom_no, no ORDER BY level) AS rn, company FROM production_cte_tree WHERE production_cte_tree.level > 0
    ), 
    ------------------
    -- Assembly BOM --
    ------------------
    assembly_cte_tree AS (
        SELECT DISTINCT CAST(NULL AS NVARCHAR(20)) AS bom_no, 
                bc.[ParentItemNo] AS no, 
                /*CAST([ParentItemNo] AS NVARCHAR(MAX)) AS trace,*/ 
                CAST(0.0 AS NUMERIC(38,20)) AS qty, 0 AS level,
                bc.Company
        FROM [cus].bom_component bc JOIN [cus].item i ON i.No = bc.[ParentItemNo] AND bc.Company = i.Company
        -- Status 1 = Certified, Replenishment System 1 = Production Order
        WHERE i.[ReplenishmentSystem] = 'Assembly'
    
        UNION ALL
    
        SELECT CAST(l.[ParentItemNo] AS NVARCHAR(20)) AS bom_no, l.[No] AS no, /*CAST(CONCAT(st.trace, '->', l.[No]) AS NVARCHAR(MAX)) AS trace,*/ CAST(l.[Quantityper] AS NUMERIC(38,20)),  st.level + 1 AS level, l.Company
        FROM assembly_cte_tree st JOIN [cus].bom_component l ON st.no = l.[ParentItemNo] AND st.Company = l.Company
    ),
    assembly_cte_top_level_removed AS (
        SELECT bom_no, no, qty, /*trace,*/ ROW_NUMBER() OVER (PARTITION BY bom_no, no ORDER BY level) AS rn, Company FROM assembly_cte_tree WHERE assembly_cte_tree.level > 0
    )
    SELECT
        CAST(header_no AS NVARCHAR(255)) AS ITEM_NO,
        CAST(no AS NVARCHAR(255))        AS COMPONENT_ITEM_NO,
        CAST(qty AS DECIMAL(18,4))       AS QUANTITY
        -- if you are having problems with this query you can copy this query to a new windows and uncomment the trace column
        --,trace
        , 'Production BOM' AS [source]
        , Company
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
        , Company
    FROM
        assembly_cte_top_level_removed
    WHERE
        rn = 1

