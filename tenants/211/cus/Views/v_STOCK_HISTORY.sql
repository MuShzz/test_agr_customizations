CREATE VIEW [cus].v_STOCK_HISTORY
AS
SELECT
    CAST(NULL AS bigint) AS [TRANSACTION_ID],
    CAST(orderForm_lineItems_code AS nvarchar(255)) AS [ITEM_NO],
    CAST(i.warehouseCode AS nvarchar(255)) AS [LOCATION_NO],
    CAST(ol.created AS date) AS [DATE],
    CAST(-orderForm_lineItems_quantity AS decimal(18,4)) AS [STOCK_MOVE],
    CAST(NULL AS decimal(18,4)) AS [STOCK_LEVEL]
FROM cus.OrdersLines ol
     INNER JOIN cus.Inventory i ON i.sku = ol.orderForm_lineItems_code
WHERE ol.status != 'OrderCancelled'
UNION ALL

SELECT
    CAST(NULL AS bigint) AS [TRANSACTION_ID],
    CAST(purchaseOrderForm_lineItems_code AS nvarchar(255)) AS [ITEM_NO],
    CAST(i.warehouseCode AS nvarchar(255)) AS [LOCATION_NO],
    CAST(pod.created AS date) AS [DATE],
    CAST(purchaseOrderForm_lineItems_quantity AS decimal(18,4)) AS [STOCK_MOVE],
    CAST(NULL AS decimal(18,4)) AS [STOCK_LEVEL]
FROM cus.PurchaseOrders po
    INNER JOIN cus.PurchaseOrdersDeliveries pod ON po.id = pod.id and deliveryStatus = 'Completed'
    INNER JOIN cus.Inventory i ON i.sku = po.purchaseOrderForm_lineItems_code
WHERE status != 'Cancelled'
