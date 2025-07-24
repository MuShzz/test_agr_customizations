
-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for BOM consumption history
--
-- 19.11.2024.HMH   Created
-- ====================================================================================================


CREATE VIEW [visma_sql_cus].[v_BOM_CONSUMPTION_HISTORY] AS
	


	SELECT CAST(ROW_NUMBER() OVER (ORDER BY [DATE], [ITEM_NO], [LOCATION_NO]) AS BIGINT) AS [TRANSACTION_ID],
		   [ITEM_NO],
		   [LOCATION_NO],
		   [DATE],
		   [UNIT_QTY]
	FROM (SELECT
			CAST(ProdTr.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
			CAST(ProdTr.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST((CONVERT(DATE, CAST(ProdTr.FinDt AS VARCHAR(8)), 112)) AS DATE) AS [DATE],
			CAST(ProdTr.StcMov AS DECIMAL(18, 4)) AS [UNIT_QTY]
		FROM
			[visma_sql].ProdTr
			LEFT JOIN [visma_sql].Prod on Prod.ProdNo = ProdTr.ProdNo
			LEFT JOIN [visma_sql].Stc on Stc.StcNo = ProdTr.FrStc
		WHERE
			--(Stc.Fax = 'ST' OR Stc.Fax = 'WH') AND 
			ProdTr.TrTp = 5 AND 
			ProdTr.StcMov != 0 AND ProdTr.FinDt > 0
		GROUP BY ProdTr.ProdNo, ProdTr.FrStc, ProdTr.FinDt, ProdTr.StcMov) t1

