CREATE VIEW [cus].v_STOCK_HISTORY
             AS
            SELECT
               CAST(NULL AS bigint) AS [TRANSACTION_ID],
               CAST(ITEM_NO AS nvarchar(255)) AS [ITEM_NO],
               CAST(LOCATION_NO AS nvarchar(255)) AS [LOCATION_NO],
               CAST(CAST(DATEADD(HOUR,-20,GETDATE()) AS DATE) AS date) AS [DATE],
               CAST(0 AS decimal(18,4)) AS [STOCK_MOVE],
               CAST(STOCK_UNITS AS decimal(18,4)) AS [STOCK_LEVEL]
                FROM cus.v_STOCK_LEVEL

