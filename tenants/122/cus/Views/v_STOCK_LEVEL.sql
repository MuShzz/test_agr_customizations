




    CREATE VIEW [cus].[v_STOCK_LEVEL] AS
       SELECT
            CAST(it.ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(wh.WhsCode AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS EXPIRE_DATE,
            CAST(SUM(wh.OnHand) AS DECIMAL(18, 4)) AS [STOCK_UNITS]
		FROM
			[cus].OITM it
			JOIN [cus].OITW wh ON wh.ItemCode = it.ItemCode
		GROUP BY
			it.ItemCode, wh.WhsCode
		HAVING 
			SUM(wh.OnHand) > 0


