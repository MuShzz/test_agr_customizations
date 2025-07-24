
CREATE VIEW [visma_sql_cus].[v_SALES_HISTORY] AS
	 
	SELECT
		CAST(ROW_NUMBER() OVER (ORDER BY [DATE], [ITEM_NO], [LOCATION_NO]) AS BIGINT) AS [TRANSACTION_ID],
		[ITEM_NO],
		[LOCATION_NO],
		[DATE],
		[SALE],
		[CUSTOMER_NO],	
		[REFERENCE_NO],
		[TRANSFER],
        [IS_EXCLUDED] FROM (
			SELECT
				CAST(ProdTr.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
				CAST(ProdTr.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
				CAST((CONVERT(DATE, CAST(ProdTr.FinDt AS VARCHAR(8)), 112)) AS DATE) AS [DATE],
				CAST(ProdTr.StcMov * -1 AS DECIMAL(18, 4)) AS [SALE],
				CAST(ProdTr.CustNo AS NVARCHAR(255)) AS [CUSTOMER_NO],	
				CAST(ProdTr.OrdNo AS NVARCHAR(255)) AS [REFERENCE_NO],
				CAST(0 AS DECIMAL(18,4)) AS [TRANSFER],
				CAST(0 AS BIT) AS [IS_EXCLUDED]
			FROM
				[visma_sql].ProdTr
				LEFT JOIN [visma_sql].Ord ON Ord.OrdNo = ProdTr.OrdNo 
				LEFT JOIN [visma_sql_cus].Prod ON Prod.ProdNo = ProdTr.ProdNo
				LEFT JOIN [visma_sql].Stc ON Stc.StcNo = ProdTr.FrStc
			WHERE
				ProdTr.TrTp = 1 AND ProdTr.TransSt != ProdTr.TransSt|16 AND 
				ProdTr.StcMov != 0 AND ProdTr.FinDt > 0 
			GROUP BY
				ProdTr.ProdNo, ProdTr.FrStc, ProdTr.FinDt, ProdTr.StcMov, ProdTr.CustNo,ProdTr.OrdNo
		) T1

