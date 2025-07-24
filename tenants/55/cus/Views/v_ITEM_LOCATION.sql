



    CREATE VIEW [cus].[v_ITEM_LOCATION] AS

	WITH RankedProducts AS (
       SELECT 
	   CAST(P.[ProdNo] AS NVARCHAR(255))			AS [ITEM_NO],
       CAST(ISNULL(S.[StcNo], 1) AS NVARCHAR(255))	AS [LOCATION_NO],

       CAST(s.MinBal AS DECIMAL(18,4))				AS [SAFETY_STOCK_UNITS],
       CAST(NULL AS DECIMAL(18,4))					AS [MIN_DISPLAY_STOCK],

       CAST(S.MaxBal AS DECIMAL(18,4))				AS [MAX_STOCK],
       CAST(IIF(P.Gr3 IN (1, 4, 5), 0, 1) AS BIT)	AS [CLOSED_FOR_ORDERING],
       CAST(NULL AS NVARCHAR(255))					AS [RESPONSIBLE],
       CAST(p.Descr AS NVARCHAR(255))				AS [NAME],
       CAST(NULL AS NVARCHAR(1000))					AS [DESCRIPTION],
       CAST(P.[Gr5] AS NVARCHAR(255))				AS [PRIMARY_VENDOR_NO],
       CAST(ISNULL(D.[DelTm] + D.[TanspTm], 0) AS SMALLINT)                AS [PURCHASE_LEAD_TIME_DAYS],
       CAST(NULL AS SMALLINT)                AS [TRANSFER_LEAD_TIME_DAYS],
       CAST(NULL AS SMALLINT)                AS [ORDER_FREQUENCY_DAYS],
       CAST(NULL AS SMALLINT)                AS [ORDER_COVERAGE_DAYS],
       CAST(NULL AS DECIMAL(18,4))           AS [MIN_ORDER_QTY],
       CAST(D.SupProd AS NVARCHAR(50))            AS [ORIGINAL_NO],
       CAST(ISNULL(PDM.SalePr - PDM.SaleDcP * PDM.SalePr, 0) AS DECIMAL(18,4))           AS [SALE_PRICE],
       CAST(ISNULL(D.SupPrice, 0) AS DECIMAL(18,4))           AS [COST_PRICE],
       CAST(S.PhCstPr AS DECIMAL(18,4))           AS [PURCHASE_PRICE],
       CAST(ISNULL(TRY_CAST(P.Inf AS NUMERIC), 1) AS DECIMAL(18,4))           AS [ORDER_MULTIPLE],
       CAST(ISNULL(TRY_CAST(P.Inf AS NUMERIC), 0) AS DECIMAL(18,4))           AS [QTY_PALLET],
       CAST(p.VolU AS DECIMAL(18,4))           AS [VOLUME],
       CAST(P.NWgtU AS DECIMAL(18,4))           AS [WEIGHT],
       CAST(0 AS DECIMAL(18,4))           AS [REORDER_POINT],
       CAST(1 AS BIT)                     AS [INCLUDE_IN_AGR],
       CAST(IIF(P.Gr3 IN (1, 4, 5), 0, 1) AS BIT)                     AS [CLOSED],
	   ROW_NUMBER() OVER (PARTITION BY P.[ProdNo] ORDER BY S.PhCstPr DESC) AS RowNum
	    , CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
       FROM
        cus.Prod P
        LEFT JOIN [cus].[StcBal] S ON S.[ProdNo] = P.[ProdNo] AND S.[StcNo] = 1
        LEFT JOIN [cus].[Stc] ST ON ST.StcNo = S.StcNo
        LEFT JOIN [cus].[Actor] A ON P.Gr5 = A.SupNo AND S.NrmSup = A.SupNo
        LEFT JOIN [cus].[DelAlt] D ON D.ProdNo = P.ProdNo AND D.SupNo = P.GR5
        LEFT JOIN [cus].[Unit] U ON U.[Un] = P.[StSaleUn]
        LEFT JOIN [cus].[Unit] U_Purch ON U_Purch.[Un] = D.[StPurcUn]
        LEFT JOIN [cus].[PrDcMat] PDM ON P.ProdNo = PDM.ProdNo
            AND RIGHT(PDM.Inf, 2) = RIGHT(CAST(YEAR(GETDATE()) AS NVARCHAR), 2)
            AND LEFT(PDM.Inf, 9) = 'LISTEPRIS'
    WHERE
        GR5 > 0 )

	SELECT *
	FROM RankedProducts
	WHERE RowNum = 1

