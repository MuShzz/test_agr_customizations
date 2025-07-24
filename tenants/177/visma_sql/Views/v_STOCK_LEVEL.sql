
-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for stock level
--
-- 19.11.2024.HMH   Created
-- ====================================================================================================


CREATE VIEW [visma_sql_cus].[v_STOCK_LEVEL] AS
	   
	SELECT
		CAST(StcBal.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(StcBal.StcNo AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS [EXPIRE_DATE],
		CAST(StcBal.Bal + StcBal.StcInc AS DECIMAL(18,4)) AS [STOCK_UNITS]
	FROM
		[visma_sql].StcBal
		LEFT JOIN [visma_sql_cus].Prod ON Prod.ProdNo = StcBal.ProdNo
		LEFT JOIN [visma_sql].Stc ON Stc.StcNo = StcBal.StcNo
	WHERE
		StcBal.StcNo = Prod.NrmStc

