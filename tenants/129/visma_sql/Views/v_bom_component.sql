


-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for BOM components
--
-- 19.11.2024.HMH   Created
-- ====================================================================================================

CREATE VIEW [visma_sql_cus].[v_bom_component] AS
	
	SELECT DISTINCT
		CAST(Struct.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(Struct.SubProd AS NVARCHAR(255)) AS [COMPONENT_ITEM_NO],
		CAST(Struct.NoPerStr AS DECIMAL(18,4)) AS [QUANTITY]
	FROM
		[visma_sql].Struct
		LEFT JOIN [visma_sql].Prod on Prod.ProdNo = Struct.ProdNo
		LEFT JOIN [visma_sql].Prod SubProd on SubProd.ProdNo = Struct.SubProd
		LEFT JOIN [visma_sql].Stc SubStc on SubStc.StcNo = SubProd.NrmStc
	WHERE 1=0
		--(SubStc.Fax = 'ST' or SubStc.Fax = 'WH') and 
		--Prod.ExpStr = Prod.ExpStr|64 and Struct.PrM4 != Struct.PrM4|16384 
	GROUP BY
		Struct.ProdNo, Struct.SubProd, Struct.NoPerStr

