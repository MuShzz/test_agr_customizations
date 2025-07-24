

	CREATE VIEW [cus].[v_STOCK_LEVEL] AS
       SELECT
            CAST([Product.Code] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST((SELECT TOP 1 Code FROM cus.Branch) AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS [EXPIRE_DATE],
            CAST([StockLevel] AS DECIMAL(18, 4)) AS [STOCK_UNITS]
      FROM  cus.ProductBranchStatistics

