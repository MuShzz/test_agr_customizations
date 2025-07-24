


CREATE VIEW [visma_sql_cus].[v_ITEM] AS

WITH RankedEntries AS (
	   SELECT
        CAST(P.[ProdNo] AS NVARCHAR(255)) AS [NO],
        CAST(ISNULL(P.[Descr], P.[ProdNo]) AS NVARCHAR(255)) AS [NAME],
        CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(D.[SupNo] AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST(ISNULL(D.[DelTm] + D.[TanspTm] + D.[AdmTm] + D.[ProdTm], 0) AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS],
        CAST(0 AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
        CAST(D.SupProd AS NVARCHAR(50)) AS [ORIGINAL_NO],
        CAST(CASE WHEN S.PurcProc IN (892,576,64,256,832,512) THEN 1 ELSE 0 END AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(A.Nm AS NVARCHAR(255)) AS [RESPONSIBLE],
        CAST(MAX(ISNULL(PDM.SalePr-PDM.SaleDcP*PDM.SalePr, 0)) AS DECIMAL(18,4)) AS [SALE_PRICE],
        --CAST(MAX(ISNULL(PDM.CstPr/IIF(PDM.Un=0, 1, PDM.Un), 0)) AS DECIMAL(18,4)) AS [COST_PRICE],
		CAST(S.PhCstPr AS DECIMAL(18, 4)) AS [COST_PRICE],
        CAST(MAX(ISNULL(PDM.[PurcPr] * (1- PDM.[PurcDcP]/100) * CE.[SalesRt], 0)) AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(ISNULL(TRY_CAST(P.Inf AS NUMERIC),1) AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(ISNULL(TRY_CAST(P.Inf AS NUMERIC),0) AS DECIMAL(18,4)) AS [QTY_PALLET],
        CAST(P.VolU AS DECIMAL(18,6)) AS [VOLUME],
        CAST(P.NWgtU AS DECIMAL(18,6)) AS [WEIGHT],
        CAST(S.MaxBal AS DECIMAL(18,4)) AS [MAX_STOCK],
        CAST(p.ProdPrGr AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(p.ProdTp2 AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        IIF(p.ProdTp3 <> 0, CAST(p.ProdNo AS NVARCHAR(255)), NULL) AS [ITEM_GROUP_NO_LVL_3],
        CAST(U.[Descr] AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(U_Purch.[Descr] AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(ISNULL(U_Purch.[StUnRt],1) AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(IIF(P.ProdTp4 = 409, 1, 0) AS BIT) AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
		CAST(0 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(CASE WHEN S.PurcProc IN (892,576,64,256,832,512) THEN 1 ELSE 0 END AS BIT) AS CLOSED,
		CAST(0 AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
		ROW_NUMBER() OVER (PARTITION BY P.[ProdNo] ORDER BY PDM.FrDt DESC) AS RowNum
	FROM visma_sql.Prod P
		LEFT JOIN [visma_sql].[StcBal] S ON S.[ProdNo]=P.[ProdNo] AND S.[StcNo]=1
		LEFT JOIN [visma_sql].[Stc] ST ON ST.StcNo = S.StcNo 
		LEFT JOIN [visma_sql].[Actor] A ON P.Gr5 = A.SupNo AND S.NrmSup=A.SupNo AND SupNo <> 0
		LEFT JOIN (
					SELECT D.ProdNo, MIN(D.LnNo) AS MinLnNo
					FROM visma_sql.DelAlt D
					GROUP BY D.ProdNo
					) MinDelAlt ON MinDelAlt.ProdNo = P.ProdNo
		LEFT JOIN visma_sql.DelAlt D ON D.ProdNo = MinDelAlt.ProdNo AND D.LnNo = MinDelAlt.MinLnNo
		LEFT JOIN [visma_sql].[Unit] U ON U.[Un] = P.[StSaleUn]
		LEFT JOIN [visma_sql].[Unit] U_Purch ON U_Purch.[Un] = D.[StPurcUn]
		LEFT JOIN [visma_sql].[PrDcMat] PDM ON P.ProdNo = PDM.ProdNo 
		INNER JOIN [visma_sql].[Cur] CE ON PDM.PurcCur = CE.CurNo AND CE.CurNo > 0 AND CE.SalesRt IS NOT NULL 
	   -- AND LEFT(PDM.Inf,9) = 'LISTEPRIS'
	   WHERE p.R4 NOT IN (995,996)
	GROUP BY P.ProdNo, P.Descr, D.SupNo, D.DelTm, D.SupProd, S.PurcProc, A.Nm, P.Inf, P.VolU, P.NWgtU, S.MaxBal, P.ProdPrGr, P.ProdTp2, P.ProdTp3, U.Descr, U_Purch.StUnRt, U_Purch.Descr, P.ProdTp4, S.PurcProc, D.DelTm, D.AdmTm, D.TanspTm, D.ProdTm, PDM.PurcPr, PDM.PurcDcP, CE.SalesRt, PDM.FrDt,S.PhCstPr
	
	)
SELECT *
FROM RankedEntries
WHERE RowNum = 1;


