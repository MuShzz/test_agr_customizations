CREATE VIEW [cus].[v_STOCK_HISTORY] AS
-- 1. Generate date dimension
WITH date_dim AS (
    SELECT DATEADD(DAY, n, '2022-05-01') AS [DATE]
    FROM (
        SELECT TOP (DATEDIFF(DAY, '2022-05-01', GETDATE()) + 1)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
        FROM sys.all_objects
    ) AS numbers
),

-- 2. Original stock movements
stock_history AS (
    SELECT 
        [Product.Code] AS ITEM_NO, 
        [StockBin.Location.Branch.Code] AS LOCATION_NO,
        CAST([_Owner_.Date] AS DATE) AS DATE,
        CAST(Quantity AS DECIMAL(18, 4)) AS STOCK_MOVE
    FROM cus.POReceipts 
    WHERE CAST([_Owner_.Date] AS DATE) >= '2022-05-01'

    UNION ALL

    SELECT 
        sii.[$Product.Code], 
        si.[Branch.Code],
        CAST(si.Date AS DATE),
        CAST(-sii.[$Quantity] AS DECIMAL(18, 4))
    FROM cus.SalesInvoice si 
    JOIN cus.SalesInvoiceItems sii ON si.Number = sii.Number 
    WHERE CAST(si.Date AS DATE) >= '2022-05-01'

    UNION ALL

    SELECT      
        [Product.Code],
        [StockBin.Location.Branch.Code],
        CAST([_Owner_.Date] AS DATE),
        CAST(Quantity AS DECIMAL(18, 4))
    FROM cus.StockMovements
    WHERE CAST([_Owner_.Date] AS DATE) >= '2022-05-01'

    UNION ALL

    SELECT 
        [Product.Code],
        [StockBin.Location.Branch.Code],
        CAST([_Owner_.Date] AS DATE),
        CAST(Quantity AS DECIMAL(18, 4))
    FROM cus.BOMConsumption
    WHERE [_Owner_.Date] >= '2022-05-01'
),

-- 3. Get all unique item-location combos
item_location_combos AS (
    SELECT DISTINCT ITEM_NO, LOCATION_NO
    FROM stock_history
),

-- 4. Combine dates with item/location pairs
calendar AS (
    SELECT 
        il.ITEM_NO,
        il.LOCATION_NO,
        d.[DATE]
    FROM item_location_combos il
    CROSS JOIN date_dim d
),

-- 5. Sum daily movements
daily_stock AS (
    SELECT
        ITEM_NO,
        LOCATION_NO,
        DATE,
        SUM(STOCK_MOVE) AS DAILY_MOVE
    FROM stock_history
    GROUP BY ITEM_NO, LOCATION_NO, DATE
),

-- 6. Join calendar with daily moves
calendar_with_moves AS (
    SELECT 
        c.ITEM_NO,
        c.LOCATION_NO,
        c.DATE,
        ISNULL(ds.DAILY_MOVE, 0) AS STOCK_MOVE
    FROM calendar c
    LEFT JOIN daily_stock ds 
        ON c.ITEM_NO = ds.ITEM_NO 
        AND c.LOCATION_NO = ds.LOCATION_NO 
        AND c.DATE = ds.DATE
),

-- 7. Compute cumulative stock per day (oldest to newest)
cumulative_stock AS (
    SELECT 
        *,
        SUM(STOCK_MOVE) OVER (
            PARTITION BY ITEM_NO, LOCATION_NO
            ORDER BY DATE DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS CUMULATIVE_STOCK
    FROM calendar_with_moves
)

-- 8. Final output: calculate stock level based on ProductBranchStatistics
SELECT
	ABS(CAST(HASHBYTES('SHA2_256', CAST(NEWID() AS VARBINARY)) AS BIGINT)) AS TRANSACTION_ID,
    cs.ITEM_NO,
    cs.LOCATION_NO,
    cs.DATE,
    cs.STOCK_MOVE,
    (pbs.StockLevel - cs.CUMULATIVE_STOCK) AS STOCK_LEVEL
FROM cumulative_stock cs
JOIN cus.ProductBranchStatistics pbs 
    ON cs.ITEM_NO = pbs.[Product.Code] 

