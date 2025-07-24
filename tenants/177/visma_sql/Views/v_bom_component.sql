CREATE VIEW [visma_sql_cus].[v_bom_component] AS
	
	SELECT
		CAST(Struct.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(Struct.SubProd AS NVARCHAR(255)) AS [COMPONENT_ITEM_NO],
		CAST(Struct.NoPerStr AS DECIMAL(18,4)) AS [QUANTITY]
	FROM
		[visma_sql].Struct
		LEFT JOIN [visma_sql_cus].Prod on Prod.ProdNo = Struct.ProdNo
		LEFT JOIN [visma_sql_cus].Prod SubProd on SubProd.ProdNo = Struct.SubProd
		LEFT JOIN [visma_sql].Stc SubStc on SubStc.StcNo = SubProd.NrmStc
	WHERE CAST(Struct.SubProd AS NVARCHAR(255)) != ''
	GROUP BY
		Struct.ProdNo, Struct.SubProd, Struct.NoPerStr

