





-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Visma SQL view for undelivered purchase orders - SSA-4
--
-- 06.03.2025.BF   Created

-- ====================================================================================================
CREATE VIEW [visma_sql_cus].[v_CC_createdInVisma] AS

		SELECT
			CAST(Prod.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
			prod.CreDt,
			CASE WHEN prod.CreDt > 0 THEN (CONVERT(DATE, CAST(prod.CreDt AS VARCHAR(8)), 112)) ELSE NULL END AS [createdInVisma]
		FROM
			[visma_sql].Prod 
			
			

