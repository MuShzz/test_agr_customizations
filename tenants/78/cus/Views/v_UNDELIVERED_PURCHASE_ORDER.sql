

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Quick Books Desktop
--
--  23.09.2024.TO   Altered
-- ===============================================================================

    CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
       SELECT
            CAST(pol.[RefNumber] AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
            CAST(pol.[PurchaseOrderLineItemRefFullName] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(pol.InventorySiteRefFullName AS NVARCHAR(255)) AS [LOCATION_NO],
            MIN(CAST(pol.[ExpectedDate] AS DATE)) AS [DELIVERY_DATE],
            CAST(SUM(pol.[PurchaseOrderLineQuantity]-pol.PurchaseOrderLineReceivedQuantity) AS DECIMAL(18, 4)) AS [QUANTITY]
       FROM [cus].[PurchaseOrderLine] pol  
	 WHERE (pol.[PurchaseOrderLineQuantity]-pol.PurchaseOrderLineReceivedQuantity) > 0 AND pol.[PurchaseOrderLineIsManuallyClosed] = 0 
			AND pol.InventorySiteRefFullName IS NOT NULL AND pol.[ExpectedDate] IS NOT NULL
			AND pol.[RefNumber] IS NOT NULL --06.06.2024.AEK added because daily was failing
    GROUP BY
        pol.[RefNumber], pol.InventorySiteRefFullName, pol.[PurchaseOrderLineItemRefFullName]



