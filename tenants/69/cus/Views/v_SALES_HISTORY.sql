CREATE VIEW [cus].v_SALES_HISTORY
AS
SELECT CAST(NULL AS bigint)                   AS [TRANSACTION_ID],
       CAST(product_item_no AS nvarchar(255)) AS [ITEM_NO],
       CAST(location_no AS nvarchar(255))     AS [LOCATION_NO],
       CAST(date AS date)                     AS [DATE],
       CAST(sale AS decimal(18, 4))           AS [SALE],
       CAST('' AS nvarchar(255))              AS [CUSTOMER_NO],
       CAST('' AS nvarchar(255))              AS [REFERENCE_NO],
       CAST(0 AS bit)                         AS [IS_EXCLUDED]
FROM cus.sale_history sh
