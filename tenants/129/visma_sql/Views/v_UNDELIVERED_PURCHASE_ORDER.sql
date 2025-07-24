




-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for undelivered purchase orders
--
-- 19.11.2024.HMH   Created
-- 05.03.2025.BF	altered columns for date and Qty SSA-3
-- ====================================================================================================
CREATE VIEW [visma_sql_cus].[v_UNDELIVERED_PURCHASE_ORDER] AS

		SELECT
			CAST(ProdTr.OrdNo AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
			CAST(Prod.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
			CAST(ProdTr.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(CASE WHEN ProdTr.DelDt > 0 THEN (CONVERT(DATE, CAST(ProdTr.DelDt AS VARCHAR(8)), 112)) ELSE CAST(DATEADD(DAY, 1, GETDATE()) AS DATE) END AS DATE) AS [DELIVERY_DATE],
			SUM(CAST(ProdTr.Ininc  AS DECIMAL(18,4))) AS [QUANTITY]
		FROM
			[visma_sql].Prod 
			INNER JOIN [visma_sql].ProdTr ON Prod.ProdNo = ProdTr.ProdNo
		WHERE ProdTr.FrStc = 1 AND ProdTr.TrTp = 6
		--AND ProdTr.OrdNo='259045' AND ProdTr.ProdNo='SC-615BS'
		GROUP BY ProdTr.OrdNo, Prod.ProdNo, ProdTr.FrStc, CAST(CASE WHEN ProdTr.DelDt > 0 THEN (CONVERT(DATE, CAST(ProdTr.DelDt AS VARCHAR(8)), 112)) ELSE CAST(DATEADD(DAY, 1, GETDATE()) AS DATE) END AS DATE)
		HAVING SUM(CAST(ProdTr.Ininc  AS DECIMAL(18,4)))>0
			

