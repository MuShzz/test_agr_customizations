CREATE VIEW [cus].[v_UNDELIVERED_BOM_ORDER] AS
	
	WITH all_components AS (
		SELECT
			CAST(jm.JobNum AS NVARCHAR(128)) AS Component_ORDER_NO,
			MAX(IIF(jm.IssuedQty > 0, 1, 0)) AS all_issued_flag,
			COUNT(*) AS total_components,
			SUM(IIF(jm.IssuedQty > 0, 1, 0)) AS issued_components
		FROM cus.JobMtl jm
		JOIN cus.v_bom_component bc ON bc.COMPONENT_ITEM_NO=jm.PartNum
		WHERE 1=0 --BF shutting off
		and jm.JobComplete=0
		AND jm.JobNum NOT LIKE 'PMRP%'
		--AND jm.JobNum='029977-23-1'
		GROUP BY
			jm.JobNum
	)

	SELECT
		CAST(jh.JobNum AS NVARCHAR(128)) AS [BOM_ORDER_NO],
		CAST(jh.[PartNum] AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(jh.Plant AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(ISNULL(jh.[DueDate],GETDATE()) AS DATE) AS [DELIVERY_DATE],
		CAST(SUM(jh.ProdQty-jp.ShippedQty) AS DECIMAL(18, 4)) AS [QUANTITY]
	FROM cus.JobHead jh
	JOIN cus.JobPart jp ON jp.JobNum=jh.JobNum AND jp.PartNum=jh.PartNum AND jp.Plant=jh.Plant
	JOIN all_components ac ON ac.Component_ORDER_NO=jh.JobNum
	WHERE 1=0 --BF shutting off
	and jh.JobFirm=1 AND jh.JobComplete<>1
	AND jh.PartNum IN (
						SELECT DISTINCT bc.ITEM_NO  -- parent item
						FROM cus.v_bom_component bc
						INNER JOIN cus.v_COMMITTED_DEMAND cd ON bc.COMPONENT_ITEM_NO = cd.ITEM_NO)
	AND ac.issued_components = ac.total_components
	--AND jh.PartNum='U5002/03'
	GROUP BY
		jh.JobNum, jh.PartNum,jh.Plant,jh.DueDate
