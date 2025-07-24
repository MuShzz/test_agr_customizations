CREATE VIEW [cus].v_OPEN_SALES_ORDER
             AS
          WITH cte AS (
	SELECT 
		CAST([soi].[SalesOrder] AS VARCHAR(20))+'-'+CAST(soi.ProductionPlant AS VARCHAR(10))+': ' + CAST(ISNULL([ConfirmedDeliveryDate],[RequestedDeliveryDate]) AS NVARCHAR(128)) AS SALES_ORDER_NO,
		CAST(soi.ProductionPlant AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(soi.Material AS NVARCHAR(255)) AS PRODUCT_ITEM_NO,
		soi.salesOrder,
		soi.SalesOrderItem,

		CAST(soi.[RequestedQuantity] AS DECIMAL(18,4)) AS QUANTITY,
		CAST(sosl.[ScheduleLineOrderQuantity] AS DECIMAL(18,4)) AS QUANTITY3,	
	ISNULL([ConfirmedDeliveryDate],[RequestedDeliveryDate]) AS DELIVERY_DATE,
	sosl.ScheduleLine,

		ROW_NUMBER() OVER (PARTITION BY soi.SalesOrder, soi.SalesOrderItem ORDER BY sosl.ScheduleLine DESC) AS RowNum

FROM [cus].[OpenSalesOrderItems] soi
INNER JOIN [cus].[v_SalesOrderScheduleLine] sosl ON sosl.SalesOrder = soi.SalesOrder AND soi.SalesOrderItem=sosl.SalesOrderItem
WHERE soi.ProductionPlant<>'7090' 

)
,cte_delivered AS 

(
SELECT 
SalesOrder,
SalesOrderItem,
SUM(CAST(DeliveredQtyInOrderQtyUnit AS DECIMAL(18,4))) AS [DeliveredQtyInOrderQtyUnit]
FROM cus.OpenSalesOrderScheduleLine
GROUP BY
SalesOrder,
SalesOrderItem
)

SELECT	CAST(cte.SALES_ORDER_NO AS nvarchar(128)) AS [SALES_ORDER_NO],
        CAST(cte.PRODUCT_ITEM_NO AS nvarchar(255)) AS [ITEM_NO],
		CAST(cte.LOCATION_NO AS nvarchar(255)) AS [LOCATION_NO],
		SUM(cte.QUANTITY) -SUM(ISNULL(cd.DeliveredQtyInOrderQtyUnit,0)) AS QUANTITY,
		CAST(NULL AS nvarchar(255)) AS [CUSTOMER_NO],
        CAST(cte.DELIVERY_DATE AS date) AS [DELIVERY_DATE]
		FROM cte
		JOIN cte_delivered  cd ON cte.SalesOrder=cd.SalesOrder AND cte.SalesOrderItem=cd.SalesOrderItem
		WHERE cte.RowNum=1
		GROUP BY cte.SALES_ORDER_NO,
        cte.PRODUCT_ITEM_NO,
		cte.DELIVERY_DATE,
		cte.LOCATION_NO

