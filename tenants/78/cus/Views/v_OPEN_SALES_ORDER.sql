

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Quick Books Desktop
--
--  23.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
       SELECT
            CAST(sol.[RefNumber]+' - '+sol.[SalesOrderLineInventorySiteRefFullName] AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(sol.SalesOrderLineItemRefFullName AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(sol.[SalesOrderLineInventorySiteRefFullName] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(SUM(sol.[SalesOrderLineQuantity]-sol.[SalesOrderLineInvoiced]) AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(sol.[CustomerRefListID] AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(MAX(COALESCE(sol.[ShipDate], sol.[DueDate])) AS DATE) AS [DELIVERY_DATE]
       FROM [cus].[SalesOrderLine] sol
	   WHERE (sol.[SalesOrderLineQuantity]-sol.[SalesOrderLineInvoiced]) > 0 AND sol.[SalesOrderLineIsManuallyClosed] = 0 AND sol.[SalesOrderLineInventorySiteRefListID] IS NOT NULL
       GROUP BY sol.[RefNumber]+' - '+sol.[SalesOrderLineInventorySiteRefFullName], sol.SalesOrderLineItemRefFullName, sol.[SalesOrderLineInventorySiteRefFullName], sol.[CustomerRefListID]


