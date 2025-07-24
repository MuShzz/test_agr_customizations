


    CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
	WITH POL AS (
       SELECT
            CAST(O.OrdNo AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
            CAST(OL.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(OL.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
            CASE WHEN TRY_CONVERT(DATE, CAST(OL.FinDt AS NVARCHAR(8)), 112) < CAST(GETDATE() AS DATE)
		THEN TRY_CONVERT(DATE, CAST(OL.FinDt AS NVARCHAR(8)), 112) 
		ELSE TRY_CONVERT(DATE, CAST(OL.ArDt AS NVARCHAR(8)), 112) END AS [DELIVERY_DATE],
            SUM(CAST(OL.NoInvoAb AS DECIMAL(18,4))) AS [QUANTITY]
       FROM cus.Ord O 
	INNER JOIN cus.OrdLn OL ON O.OrdNo = OL.OrdNo
	WHERE OL.ProdNo <> '' 
	AND TRY_CONVERT(DATE, CAST(OL.ArDt AS NVARCHAR(8)), 112) IS NOT NULL 
	AND OL.NoInvoAb <> 0 AND TrTp = 6  AND OL.FrStc = 1
	GROUP BY O.OrdNo, OL.ProdNo, OL.FrStc, OL.ArDt, OL.ArDt, OL.FinDt)
	SELECT [purchase_order_no]
      ,[item_no]
      ,[location_no]
      ,SUM([quantity]) AS [quantity]
      ,[delivery_date]
      
	FROM POL
	GROUP BY [purchase_order_no],[item_no],[location_no],[delivery_date]
 

