CREATE VIEW [cus].v_SALES_HISTORY
AS
SELECT
    CAST(NULL AS bigint) AS [TRANSACTION_ID],
    CAST(ol.orderForm_lineItems_code AS nvarchar(255)) AS [ITEM_NO],
    CAST(i.warehouseCode AS nvarchar(255)) AS [LOCATION_NO],
    CAST(ol.created AS date) AS [DATE],
    CAST(orderForm_lineItems_quantity AS decimal(18,4)) AS [SALE],
    CAST(ISNULL(cust.customerId,'') AS nvarchar(255)) AS [CUSTOMER_NO],
    CAST('' AS nvarchar(255)) AS [REFERENCE_NO],
    CAST(0 AS bit) AS [IS_EXCLUDED]
FROM cus.OrdersLines ol
         INNER JOIN cus.Inventory i ON i.sku = ol.orderForm_lineItems_code
         LEFT JOIN cus.Customers cust ON ol.customerId = cust.customerId
WHERE ol.status != 'OrderCancelled'
