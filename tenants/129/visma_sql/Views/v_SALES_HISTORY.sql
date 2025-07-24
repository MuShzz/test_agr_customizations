






-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for sales history
--
-- 19.11.2024.HMH   Created
-- ====================================================================================================


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
            CAST((TRY_CONVERT(DATE, CAST(ProdTr.[FinDt] AS NVARCHAR(255)), 112)) AS DATE) AS [DATE],
            SUM(CAST(ProdTr.NoInvoAb AS DECIMAL(18, 4))) AS [SALE],
            CAST(ProdTr.CustNo AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(ProdTr.OrdNo AS NVARCHAR(255)) AS [REFERENCE_NO],
			CAST(0 AS BIT) AS [TRANSFER],
            CAST(0 AS BIT) AS [IS_EXCLUDED]
     FROM
		visma_sql.ProdTr
		LEFT JOIN visma_sql.Ord ON Ord.OrdNo = ProdTr.OrdNo 
		LEFT JOIN visma_sql.Prod ON Prod.ProdNo = ProdTr.ProdNo
		LEFT JOIN visma_sql.Stc ON Stc.StcNo = ProdTr.FrStc
	WHERE ProdTr.FrStc = 1 AND
		ProdTr.StcMov <> 0 AND ProdTr.FinDt > 0 
		AND ProdTr.TrTp = 1
	GROUP BY
		ProdTr.FinDt,  ProdTr.ProdNo, ProdTr.FrStc, ProdTr.FinDt, ProdTr.CustNo, ProdTr.OrdNo, Ord.OrdTp
		) T1

