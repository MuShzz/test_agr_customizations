


    CREATE VIEW [cus].[v_SALES_HISTORY] AS
       SELECT
            CAST(CONCAT(ProdTr.FinDt,100000000+ROW_NUMBER() OVER (ORDER BY ProdTr.JNo, ProdTr.TrNo, ProdTr.OrdNo)) AS NVARCHAR(255)) AS [TRANSACTION_ID],
            CAST(ProdTr.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(ProdTr.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST((TRY_CONVERT(DATE, CAST(ProdTr.[FinDt] AS NVARCHAR(255)), 112)) AS DATE) AS [DATE],
            SUM(CAST(ProdTr.NoInvoAb AS DECIMAL(18, 4))) AS [SALE],
            CAST(ProdTr.CustNo AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(ProdTr.OrdNo AS NVARCHAR(255)) AS [REFERENCE_NO],
            CAST(0 AS BIT) AS [IS_EXCLUDED]
       FROM
		cus.ProdTr
		LEFT JOIN cus.Ord ON Ord.OrdNo = ProdTr.OrdNo 
		LEFT JOIN cus.Prod ON Prod.ProdNo = ProdTr.ProdNo
		LEFT JOIN cus.Stc ON Stc.StcNo = ProdTr.FrStc
	WHERE
		ProdTr.TrTp = 1 AND ProdTr.TransSt != ProdTr.TransSt|16  AND ProdTr.StcMov != 0 AND ProdTr.FinDt > 0 AND FrStc = 1
	GROUP BY
		ProdTr.FinDt, ProdTr.JNo, ProdTr.TrNo, ProdTr.OrdNo, ProdTr.ProdNo, ProdTr.FrStc, ProdTr.FinDt, /*ProdTr.NoInvoAb,*/ ProdTr.CustNo, ProdTr.OrdNo, Ord.OrdTp

