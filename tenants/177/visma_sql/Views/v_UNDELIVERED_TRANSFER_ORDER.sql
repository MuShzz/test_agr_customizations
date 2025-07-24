CREATE VIEW [visma_sql_cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
	   

		SELECT
			CAST(OrdLn.OrdNo AS VARCHAR(128)) AS [TRANSFER_ORDER_NO],
			CAST(OrdLn.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
			CAST(OrdLn.ToStc AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(OrdLn.FrStc AS NVARCHAR(255)) AS [ORDER_FROM_LOCATION_NO],
			CAST(CASE WHEN OrdLn.CfDelDt > 0 THEN (CONVERT(DATE, CAST(OrdLn.CfDelDt AS VARCHAR(8)), 112)) 
				 WHEN OrdLn.DelDt > 0 THEN (CONVERT(DATE, CAST(OrdLn.DelDt AS VARCHAR(8)), 112))  
				 ELSE NULL END AS DATE) AS [DELIVERY_DATE],
			CAST(OrdLn.NoInvoAb AS DECIMAL(18,4)) AS [QUANTITY]
		FROM
			[visma_sql].OrdLn
			Left JOIN [visma_sql_cus].Prod on Prod.ProdNo = OrdLn.ProdNo
			Left JOIN [visma_sql].Stc on Stc.StcNo = OrdLn.ToStc
		WHERE
			OrdLn.TrTp = 8 and OrdLn.ExcPrint != OrdLn.ExcPrint|16384 and OrdLn.NoInvoAb != 0

