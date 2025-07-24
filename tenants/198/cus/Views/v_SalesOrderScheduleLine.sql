CREATE VIEW [cus].[v_SalesOrderScheduleLine]
AS

SELECT			SalesOrder,
				SalesOrderItem,
				ScheduleLine,
				--[cus].[UnixTimeConvert]([RequestedDeliveryDate]) AS RequestedDeliveryDate,
				CAST([RequestedDeliveryDate] AS DATE) AS RequestedDeliveryDate,
				 OrderQuantityUnit,
				ScheduleLineOrderQuantity	,
			   --[cus].[UnixTimeConvert]([ConfirmedDeliveryDate]) AS [ConfirmedDeliveryDate],
			   CAST([ConfirmedDeliveryDate] AS DATE) AS [ConfirmedDeliveryDate],
			   CAST([DeliveredQtyInOrderQtyUnit] AS DECIMAL(18,4)) AS [DeliveredQtyInOrderQtyUnit]
FROM [cus].OpenSalesOrderScheduleLine


