


    CREATE VIEW [cus].[v_PURCHASE_ORDER_ROUTE] AS
	WITH RankedResults AS (
       SELECT
            CAST(P.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(S.StcNo AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(D.SupNo AS NVARCHAR(255)) AS [VENDOR_NO],
            CAST(1 AS BIT) AS [PRIMARY],
            CAST(ISNULL(D.[DelTm] + D.[TanspTm], 0) AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
            CAST(1 AS DECIMAL(18, 4)) AS [MIN_ORDER_QTY],
            CAST(S.PhCstPr AS DECIMAL(18, 4)) AS [COST_PRICE],
            CAST(NULL AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
            CAST(TRY_CAST(P.Inf AS NUMERIC) AS DECIMAL(18, 4)) AS [ORDER_MULTIPLE],
            CAST(TRY_CAST(P.Inf AS NUMERIC) AS DECIMAL(18, 4)) AS [QTY_PALLET],
			ROW_NUMBER() OVER (PARTITION BY P.ProdNo ORDER BY ISNULL(D.[DelTm] + D.[TanspTm], 0) DESC) AS RowNum
       FROM cus.Prod P
		LEFT JOIN [cus].[Txt] T ON p.prodtp = t.TxtNo
		LEFT JOIN [cus].[StcBal] S ON S.[ProdNo]=P.[ProdNo] AND S.[StcNo]=1
		LEFT JOIN [cus].[Actor] A ON S.NrmSup=A.SupNo
		LEFT JOIN [cus].[DelAlt] D ON D.ProdNo=P.ProdNo AND D.SupNo=S.NrmSup
		LEFT JOIN [cus].[Stc] ST ON ST.StcNo = S.StcNo
		WHERE S.NrmSup > 0
			AND D.SupNo IS NOT NULL
	   )

	SELECT *
	FROM RankedResults
	WHERE RowNum = 1


