




-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for stock history
--
-- 19.11.2024.HMH   Created
-- ====================================================================================================


CREATE VIEW [visma_sql_cus].[v_STOCK_HISTORY] AS
	
	SELECT
		CAST(ROW_NUMBER() OVER (ORDER BY [DATE], [ITEM_NO], [LOCATION_NO]) AS BIGINT) AS [TRANSACTION_ID],
		[ITEM_NO],
		[LOCATION_NO],
		[DATE],
		[STOCK_MOVE],
		[STOCK_LEVEL]		
		FROM (       
		
		SELECT
            CAST(ProdTr.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(ProdTr.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST((TRY_CONVERT(DATE, CAST(ProdTr.[FinDt] AS NVARCHAR(255)), 112)) AS DATE) AS [DATE],
            CAST(ProdTr.StcMov AS DECIMAL(18, 4)) AS [STOCK_MOVE],
            CAST(NULL AS DECIMAL(18, 4)) AS [STOCK_LEVEL]
       FROM
			visma_sql.ProdTr 
			LEFT JOIN visma_sql.Ord ON Ord.OrdNo = ProdTr.OrdNo 
			LEFT JOIN visma_sql.Prod ON Prod.ProdNo = ProdTr.ProdNo
			LEFT JOIN visma_sql.Stc ON Stc.StcNo = ProdTr.FrStc
		WHERE
			ProdTr.FrStc = 1) 
			T1

