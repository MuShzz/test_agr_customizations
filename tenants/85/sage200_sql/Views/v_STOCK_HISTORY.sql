-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Stock transactions from sage200 to adi format
--
-- 10.01.2025.TO    Created
-- ===============================================================================
CREATE VIEW [sage200_sql_cus].[v_STOCK_HISTORY]
AS


   SELECT
        CAST([id] AS BIGINT)                            AS [TRANSACTION_ID],
        CAST([product_code] AS NVARCHAR(255))           AS [ITEM_NO],
        CAST([warehouse_name] AS NVARCHAR(255))         AS [LOCATION_NO],
        CAST([transaction_date] AS DATE)                AS [DATE],
        CAST(SUM(IIF([transaction_group_id] = 1, -[quantity], [quantity])) AS DECIMAL(18,4)) AS [STOCK_MOVE],
        CAST(NULL AS DECIMAL(18,4))                     AS [STOCK_LEVEL]
    FROM
        [sage200_sql].[v_product_transaction_views]
    WHERE [transaction_group_id] IN (1,2) -- custom
    GROUP BY
        [id], [product_code], [warehouse_name], CAST([transaction_date] AS DATE)
 

