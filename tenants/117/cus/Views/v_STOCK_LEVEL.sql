CREATE VIEW [cus].[v_STOCK_LEVEL] AS
	
    with all_stock as (
        SELECT
            CAST(pw.[PartNum]  AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(w.[Plant] AS NVARCHAR(255)) AS [LOCATION_NO],
            --SUM(CAST(pw.[OnHandQty] AS DECIMAL(18,4)))-SUM(CAST(pw.[AllocatedQty] AS DECIMAL(18,4)))+SUM(CAST(pw.NonNettableQty AS DECIMAL(18,4))) AS [STOCK_UNITS]
            SUM(CAST(pw.[OnHandQty] AS DECIMAL(18,4)))+SUM(CAST(pw.NonNettableQty AS DECIMAL(18,4))) AS [STOCK_UNITS]
        FROM cus.PartWhse pw
                 --INNER JOIN cus.PlantWhse plw ON pw.WarehouseCode = plw.WarehouseCode AND pw.PartNum = plw.PartNum
                 INNER JOIN cus.Warehse w ON w.WarehouseCode=pw.WarehouseCode
        WHERE pw.WarehouseCode NOT IN ('QA','QAP')
        --AND pw.PartNum='PKZ93'
        GROUP BY pw.[PartNum], w.[Plant]
        
        union all
        --components 
        SELECT
            CAST(jm.PartNum AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(jm.Plant AS NVARCHAR(255)) AS [LOCATION_NO],
            SUM(CAST(jm.IssuedQty AS DECIMAL(18, 4))) AS [STOCK_UNITS]
        FROM cus.JobMtl jm
        WHERE 
          jm.JobComplete=0
          and jm.IssuedComplete=1
          AND jm.JobNum NOT LIKE 'PMRP%'
          AND jm.IssuedQty>0
        GROUP BY
            jm.PartNum,
            jm.Plant
    )
    
    SELECT
		CAST(ast.ITEM_NO AS NVARCHAR(255))              AS [ITEM_NO],
		CAST(ast.LOCATION_NO AS NVARCHAR(255))          AS [LOCATION_NO],
		CAST(DATEFROMPARTS(2100, 1, 1) AS DATE)         AS EXPIRE_DATE,
		cast(SUM(ast.STOCK_UNITS) as DECIMAL(18,4))     AS [STOCK_UNITS]
	FROM all_stock ast
	    inner join core.location_mapping_setup lms on lms.locationNo=ast.LOCATION_NO
	GROUP BY 
	    ast.ITEM_NO, ast.LOCATION_NO
