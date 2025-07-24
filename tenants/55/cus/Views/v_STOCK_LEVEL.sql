



    CREATE VIEW [cus].[v_STOCK_LEVEL] AS
       SELECT
            CAST([ProdNo] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST([StcNo] AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(DATEFROMPARTS(2100, 1, 1) AS DATE)     AS EXPIRE_DATE,
            CAST([Bal]+[StcInc] AS DECIMAL(18, 4)) AS [STOCK_UNITS]
       FROM [cus].[StcBal]
	WHERE StcNo =1 --Filter on main WH?

