CREATE VIEW [cus].v_UNDELIVERED_PURCHASE_ORDER
AS
SELECT
    CAST(po.id AS varchar(128)) AS [PURCHASE_ORDER_NO],
    CAST(purchaseOrderForm_lineItems_code AS nvarchar(255)) AS [ITEM_NO],
    CAST(storeId AS nvarchar(255)) AS [LOCATION_NO],
    CAST(ISNULL(estimatedTimeOfArrival, '') AS date) AS [DELIVERY_DATE],
    CAST(purchaseOrderForm_lineItems_quantity AS decimal(18,4)) AS [QUANTITY]
FROM cus.PurchaseOrders po
         INNER JOIN cus.PurchaseOrdersDeliveries pod ON po.id = pod.id and deliveryStatus != 'Completed'
WHERE status != 'Cancelled'
