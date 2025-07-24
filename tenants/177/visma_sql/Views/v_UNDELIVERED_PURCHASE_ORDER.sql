CREATE VIEW [visma_sql_cus].[v_UNDELIVERED_PURCHASE_ORDER] AS

	SELECT
		CAST(OrdLn.OrdNo AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
		CAST(OrdLn.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(OrdLn.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(CASE WHEN OrdLn.CfDelDt > 0 THEN (CONVERT(DATE, CAST(OrdLn.CfDelDt AS VARCHAR(8)), 112)) ELSE TrDt END AS DATE) AS [DELIVERY_DATE],
		CAST(SUM(OrdLn.NoInvoAb) AS DECIMAL(18,4)) AS [QUANTITY]
	FROM
		[visma_sql].OrdLn
		Left JOIN [visma_sql_cus].Prod on Prod.ProdNo = OrdLn.ProdNo
		Left JOIN [visma_sql].Stc on Stc.StcNo = OrdLn.FrStc
	WHERE
		OrdLn.TrTp = 6 
		AND OrdLn.ExcPrint != OrdLn.ExcPrint|16384 
		AND OrdLn.NoInvoAb > 0 
	GROUP BY
		OrdNo,
		OrdLn.ProdNo,
		FrStc,
		CAST(CASE WHEN OrdLn.CfDelDt > 0 THEN (CONVERT(DATE, CAST(OrdLn.CfDelDt AS VARCHAR(8)), 112)) ELSE TrDt END AS DATE)
		


