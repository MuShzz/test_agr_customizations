CREATE TABLE [cus].[OpenSalesOrderScheduleLine] (
    [SalesOrder] NVARCHAR(128) NULL,
    [SalesOrderItem] NVARCHAR(128) NULL,
    [ScheduleLine] NVARCHAR(128) NULL,
    [RequestedDeliveryDate] DATETIME2 NULL,
    [OrderQuantityUnit] NVARCHAR(128) NULL,
    [ScheduleLineOrderQuantity] NVARCHAR(128) NULL,
    [ConfirmedDeliveryDate] DATETIME2 NULL,
    [DeliveredQtyInOrderQtyUnit] NVARCHAR(128) NULL
);
