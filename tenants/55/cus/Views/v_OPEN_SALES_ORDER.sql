



    CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
	WITH RankedOrders AS (
       SELECT
            CAST(O.OrdNo AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(OL.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(OL.FrStc AS NVARCHAR(255)) AS [LOCATION_NO],
            SUM(CAST(OL.NoInvoAb AS DECIMAL(18,4))) AS [QUANTITY],
            CAST(OL.CustNo AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(TRY_CONVERT(DATE, CAST(OL.CfDelDt AS NVARCHAR(8)), 112) AS DATE) AS [DELIVERY_DATE],
			ROW_NUMBER() OVER (PARTITION BY O.OrdNo, OL.ProdNo ORDER BY TRY_CONVERT(DATE, CAST(OL.CfDelDt AS NVARCHAR(8)), 112) DESC) AS [RowNum]
       FROM cus.Ord O 
	INNER JOIN cus.OrdLn OL ON O.OrdNo = OL.OrdNo
	WHERE OL.ProdNo <> ''
		AND TRY_CONVERT(DATE, CAST(OL.CfDelDt AS NVARCHAR(8)), 112) > CAST(GETDATE() AS DATE) 
		AND OL.NoInvoAb > 0 
		AND TrTp = 1  
		AND OL.FrStc = 1 -- No Returns since OL.NoInvoAb > 0 
	GROUP BY O.OrdNo, OL.ProdNo, OL.FrStc, TRY_CONVERT(DATE, CAST(OL.CfDelDt AS NVARCHAR(8)), 112), ol.CustNo
	)
	SELECT
		[sales_order_no],
		[item_no],
		[location_no],
		[quantity],
		[CUSTOMER_NO],
		[delivery_date]
	FROM RankedOrders
	WHERE RowNum = 1

