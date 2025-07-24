
CREATE VIEW [visma_sql_cus].[v_STOCK_HISTORY] AS
	
	SELECT
		CAST(NULL AS BIGINT) AS [TRANSACTION_ID],
		CAST(ProdTr.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(ProdTr.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST((CONVERT(DATE, CAST(ProdTr.FinDt AS VARCHAR(8)), 112)) AS DATE) AS [DATE],
		CAST(SUM(ProdTr.StcMov) AS DECIMAL(18, 4)) AS [STOCK_MOVE],
		CAST(NULL AS DECIMAL(18, 4)) AS [STOCK_LEVEL]
	FROM
		[visma_sql].ProdTr
		Left JOIN [visma_sql].Ord on Ord.OrdNo = ProdTr.OrdNo 
		Left JOIN [visma_sql_cus].Prod on Prod.ProdNo = ProdTr.ProdNo
		INNER JOIN core.location_mapping_setup lms ON lms.locationNo=ProdTr.FrStc
	WHERE
		(ProdTr.TrTp > 1 or (ProdTr.TrTp = 1 and ProdTr.TransSt != ProdTr.TransSt|16)) and 
		ProdTr.StcMov != 0 and ProdTr.FinDt > 0 and ProdTr.FrStc = Prod.NrmStc 
	GROUP BY
		ProdTr.ProdNo, ProdTr.FrStc, CAST((CONVERT(DATE, CAST(ProdTr.FinDt AS VARCHAR(8)), 112)) AS DATE)

