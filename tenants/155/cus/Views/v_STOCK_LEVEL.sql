    CREATE VIEW [cus].[v_STOCK_LEVEL] AS
WITH RankedStock AS (
    SELECT
        CAST(ITEM_NO AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(LOCATION_NO AS NVARCHAR(255)) AS [LOCATION_NO],
        CAST(
            ISNULL(
                TRY_CONVERT(DATE, DATE, 103), 
                GETDATE()
            ) 
            AS DATE
        ) AS [EXPIRE_DATE],
        CAST(STOCK_LEVEL AS INT) AS [STOCK_UNITS],
        ROW_NUMBER() OVER (
            PARTITION BY ITEM_NO, LOCATION_NO 
            ORDER BY TRY_CONVERT(DATE, DATE, 103) DESC
        ) AS rn
    FROM 
        [cus].[AGR_STOCK_HISTORY]
)
SELECT 
    ITEM_NO,
    LOCATION_NO,
    DATEFROMPARTS(2100, 1, 1) AS EXPIRE_DATE,
    STOCK_UNITS
FROM 
    RankedStock
WHERE 
    rn = 1;
