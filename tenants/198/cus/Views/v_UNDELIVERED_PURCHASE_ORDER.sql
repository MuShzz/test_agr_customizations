CREATE VIEW [cus].v_UNDELIVERED_PURCHASE_ORDER
             AS
           
 WITH cte AS (
    SELECT po.PurchaseOrder,
           po.PurchaseOrderItem,
           po.SequentialNumber,
           po.ConfirmationCategory,
           po.DeliveryDate,
           CAST(po.Quantity AS DECIMAL(18,4)) AS Quantity,
           po.CreatedOn,
           po.InboundDelivery,
           ROW_NUMBER() OVER (PARTITION BY po.PurchaseOrder, po.PurchaseOrderItem ORDER BY po.SequentialNumber DESC) AS RowNum
    FROM cus.v_UndeliveredPO po
    WHERE po.ConfirmationCategory = 'AB'
),

cte2 AS (
    SELECT cte.PurchaseOrder,
           cte.PurchaseOrderItem,
           cte.SequentialNumber,
           cte.ConfirmationCategory,
           cte.DeliveryDate,
           cte.Quantity,
           cte.CreatedOn,
           cte.InboundDelivery,
           cte.RowNum,
           SUM(cte.Quantity) OVER (PARTITION BY cte.PurchaseOrder, cte.PurchaseOrderItem ORDER BY cte.SequentialNumber DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeQuantity
    FROM cte
),

cte_final AS (
    SELECT cte2.PurchaseOrder,
           cte2.PurchaseOrderItem,
           cte2.SequentialNumber,
           cte2.ConfirmationCategory,
           cte2.DeliveryDate,
           cte2.Quantity,
           cte2.CreatedOn,
           cte2.InboundDelivery,
           cte2.RowNum,
           cte2.CumulativeQuantity,
           posl.ScheduleLineOrderQuantity
    FROM cte2
    INNER JOIN cus.OpenPurchaseOrderScheduleLine posl 
        ON posl.PurchasingDocument = cte2.PurchaseOrder
        AND posl.PurchasingDocumentItem = cte2.PurchaseOrderItem
    WHERE cte2.CumulativeQuantity <= posl.ScheduleLineOpenQuantity
)

SELECT poi.PurchaseOrder AS PURCHASE_ORDER_NO,
       poi.Material AS ITEM_NO,
       poi.Plant AS LOCATION_NO,
	   COALESCE(upo.DeliveryDate, [cus].[UnixTimeConvert](posl.[SchedLineStscDeliveryDate])) AS DELIVERY_DATE,
       SUM(
           CASE 
               WHEN upo.Quantity IS NULL 
                   THEN CAST(uom.QuantityNumerator * CAST(poi.OrderQuantity AS DECIMAL(18,4)) / CAST(uom.QuantityDenominator AS DECIMAL(18,4)) AS DECIMAL(18,4))
               ELSE 
                   uom.QuantityNumerator * upo.Quantity / CAST(uom.QuantityDenominator AS DECIMAL(18,4))
           END
       ) AS QUANTITY
FROM cus.OpenPurchaseOrderItems poi
INNER JOIN ( 
    SELECT DISTINCT PurchaseOrder, Supplier 
    FROM cus.OpenPurchaseOrders
) po ON po.PurchaseOrder = poi.PurchaseOrder
INNER JOIN [cus].[OpenPurchaseOrderScheduleLine] posl 
    ON posl.PurchasingDocument = poi.PurchaseOrder 
    AND posl.PurchasingDocumentItem = poi.PurchaseOrderItem
INNER JOIN cus.ProductUOM uom 
    ON uom.product = poi.Material 
    AND uom.alternativeunit = poi.PurchaseOrderQuantityUnit
LEFT JOIN cte_final upo 
    ON upo.PurchaseOrder = poi.PurchaseOrder 
    AND upo.PurchaseOrderItem = poi.PurchaseOrderItem
WHERE COALESCE(upo.DeliveryDate, [cus].[UnixTimeConvert](posl.[SchedLineStscDeliveryDate])) > '2023-01-01'
GROUP BY poi.PurchaseOrder,
         poi.Material, 
         poi.Plant, 
         [cus].[UnixTimeConvert](posl.[SchedLineStscDeliveryDate]),
         COALESCE(upo.DeliveryDate, [cus].[UnixTimeConvert](posl.[SchedLineStscDeliveryDate]));

