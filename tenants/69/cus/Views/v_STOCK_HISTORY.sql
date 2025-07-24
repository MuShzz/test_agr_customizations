CREATE VIEW [cus].v_STOCK_HISTORY
AS
SELECT CAST(NULL AS bigint)                   AS [TRANSACTION_ID],
       CAST(product_item_no AS nvarchar(255)) AS [ITEM_NO],
       CAST(location_no AS nvarchar(255))     AS [LOCATION_NO],
       CAST(date AS date)                     AS [DATE],
       CAST(stock_move AS decimal(18, 4))     AS [STOCK_MOVE],
       CAST(NULL AS decimal(18, 4))           AS [STOCK_LEVEL]
FROM cus.stock_history
