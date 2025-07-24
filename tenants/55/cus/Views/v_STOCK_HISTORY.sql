


    CREATE VIEW [cus].[v_STOCK_HISTORY] AS
       SELECT
            CAST(CONCAT(ptr.FinDt,100000000+ROW_NUMBER() OVER (ORDER BY ptr.JNo, ptr.TrNo, ptr.OrdNo)) AS NVARCHAR(255)) AS [TRANSACTION_ID],
            CAST(ptr.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(ptr.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST((TRY_CONVERT(DATE, CAST(ptr.[FinDt] AS NVARCHAR(255)), 112)) AS DATE) AS [DATE],
            CAST(ptr.StcMov AS DECIMAL(18, 4)) AS [STOCK_MOVE],
            CAST(NULL AS DECIMAL(18, 4)) AS [STOCK_LEVEL]
       FROM
		cus.ProdTr ptr
		LEFT JOIN cus.Ord ord ON Ord.OrdNo = ptr.OrdNo 
		LEFT JOIN cus.Prod prd ON prd.ProdNo = ptr.ProdNo
		LEFT JOIN cus.Stc stc ON stc.StcNo = ptr.FrStc
	WHERE

		(ptr.TrTp > 1 OR (ptr.TrTp = 1 AND ptr.TransSt <> ptr.TransSt|16)) AND 
		ptr.StcMov <> 0 
		AND ptr.FinDt > 0 
		AND ptr.FrStc = 1
		AND ptr.OrdNo <> 666960988

