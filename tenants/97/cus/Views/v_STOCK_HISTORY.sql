




CREATE VIEW [cus].[v_STOCK_HISTORY] AS
WITH 
    CTE1 AS (
        SELECT
            CAST([Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
            CAST('01-JLR' AS NVARCHAR(255)) AS LOCATION_NO,
            CAST([Posting Date] AS DATE) AS [DATE], 
            CAST(SUM([Quantity]) AS DECIMAL(18,4)) AS STOCK_MOVE,
            CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL,
            'JLR' AS Company
        FROM
            cus.LEGACY_SALES_HISTORY LSH
        INNER JOIN cus.Item i ON i.No_ = LSH.[Item No_]
        WHERE
            LSH.[Location Code] = '06'
            AND LSH.[Posting Date] < '2024-01-01'
            AND i.Company = 'JLR'
        GROUP BY
            [Item No_], [Variant Code], [Location Code], CAST([Posting Date] AS DATE)
    ),
    CTE2 AS (
        SELECT
            CAST([Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
            CAST('01-JLR' AS NVARCHAR(255)) AS LOCATION_NO,
            CAST([Posting Date] AS DATE) AS [DATE],
            CAST(SUM([Quantity]) AS DECIMAL(18,4)) AS STOCK_MOVE,
            CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL,
            'JLR' AS Company
        FROM
            cus.LEGACY_SALES_HISTORY LSH
        INNER JOIN cus.Item i ON i.No_ = LSH.[Item No_]
        WHERE
            LSH.[Location Code] = '01'
            AND LSH.[Posting Date] < '2024-01-01'
            AND LSH.[Posting Date] > '2022-01-01'
            AND i.Company = 'JLR'
        GROUP BY
            [Item No_], [Variant Code], [Location Code], CAST([Posting Date] AS DATE)
    ),
    STOCK_HISTORY AS (
        --ERP_BC_REST
        SELECT
            CAST([Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
            CAST([Location Code] + '-' + [Company] AS NVARCHAR(255)) AS LOCATION_NO,
            CAST([Posting Date] AS DATE) AS [DATE],
            CAST(SUM([Quantity]) AS DECIMAL(18,4)) AS STOCK_MOVE,
            CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL,
            [Company]
        FROM
            cus.ItemLedgerEntry ile
		WHERE ile.[Posting Date] != '01-01-2024' --13.11.2024.DFS emails with Ólafur and Sigurður
        GROUP BY
            [Item No_], [Variant Code], [Location Code], CAST([Posting Date] AS DATE), [Company]

        UNION ALL

        SELECT
            CAST([Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
            CAST('01-BLI' AS NVARCHAR(255)) AS LOCATION_NO,
            CAST([Posting Date] AS DATE) AS [DATE],
            CAST(SUM([Quantity]) AS DECIMAL(18,4)) AS STOCK_MOVE,
            CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL,
            'BLI' AS Company
        FROM
            cus.LEGACY_SALES_HISTORY LSH
        WHERE
            LSH.[Location Code] = '01'
            AND LSH.[Posting Date] < '2024-01-01'
        GROUP BY
            [Item No_], [Variant Code], [Location Code], CAST([Posting Date] AS DATE)

        UNION ALL

        SELECT 
            COALESCE(CTE1.ITEM_NO, CTE2.ITEM_NO) AS ITEM_NO,
            COALESCE(CTE1.LOCATION_NO, CTE2.LOCATION_NO) AS LOCATION_NO,
            COALESCE(CTE1.DATE, CTE2.DATE) AS DATE,
            COALESCE(CTE1.STOCK_MOVE, CTE2.STOCK_MOVE) AS STOCK_MOVE,
            COALESCE(CTE1.STOCK_LEVEL, CTE2.STOCK_LEVEL) AS STOCK_LEVEL,
            COALESCE(CTE1.Company, CTE2.Company) AS Company
        FROM 
            CTE1
        FULL OUTER JOIN
			CTE2 ON 
			CTE1.ITEM_NO = CTE2.ITEM_NO
			AND CTE1.LOCATION_NO = CTE2.LOCATION_NO 
			AND CTE1.DATE = CTE2.DATE

        UNION ALL

        SELECT
            CAST([Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
            CAST('08-HYU' AS NVARCHAR(255)) AS LOCATION_NO,
            CAST([Posting Date] AS DATE) AS [DATE],
            CAST(SUM([Quantity]) AS DECIMAL(18,4)) AS STOCK_MOVE,
            CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL,
            'HYU' AS Company
        FROM
            cus.LEGACY_SALES_HISTORY LSH
        WHERE
            LSH.[Location Code] = '08'
            AND LSH.[Posting Date] < '2024-01-01'
        GROUP BY
            [Item No_], [Variant Code], [Location Code], CAST([Posting Date] AS DATE)

        UNION ALL

        SELECT
            CAST([Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
            CAST('12-HYU' AS NVARCHAR(255)) AS LOCATION_NO,
            CAST([Posting Date] AS DATE) AS [DATE],
            CAST(SUM([Quantity]) AS DECIMAL(18,4)) AS STOCK_MOVE,
            CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL,
            'HYU' AS Company
        FROM
            cus.LEGACY_SALES_HISTORY LSH
        WHERE
            LSH.[Location Code] = '12'
            AND LSH.[Posting Date] < '2024-01-01'
        GROUP BY
            [Item No_], [Variant Code], [Location Code], CAST([Posting Date] AS DATE)
    )
SELECT
	CONCAT(CONVERT(VARCHAR, CAST([date] AS DATE), 112),100000000+ROW_NUMBER() OVER(ORDER BY [date])) AS [transaction_id],
	ITEM_NO,
    LOCATION_NO,
    [DATE],
    SUM(STOCK_MOVE) AS STOCK_MOVE,
    STOCK_LEVEL
FROM STOCK_HISTORY
GROUP BY
    ITEM_NO, LOCATION_NO, [DATE],
    STOCK_LEVEL, Company


