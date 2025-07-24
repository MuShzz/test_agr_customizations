

-- ===============================================================================
-- Author:      Jose, Jose e Paulo
-- Description: Stock history mapping 
--
--  20.09.2024.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_STOCK_HISTORY] 
AS
	WITH DateConverted AS (
    SELECT 
        [date],
        CONVERT(VARCHAR, CAST([date] AS DATE), 112) AS [date_str],
        [item_no],
        [location_no],
        [stock_move]
    FROM cus.Stock_History
	)
       SELECT
            CAST(CONCAT([date_str], 100000000 + (ROW_NUMBER() OVER (PARTITION BY [date_str] ORDER BY [date], [item_no], [location_no]))) AS NVARCHAR(255)) AS [TRANSACTION_ID],
            CAST([item_no] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST([location_no] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST([date] AS DATE) AS [DATE],
            CAST([stock_move] AS DECIMAL(18, 4)) AS [STOCK_MOVE],
            CAST(NULL AS DECIMAL(18, 4)) AS [STOCK_LEVEL]
      FROM DateConverted;


