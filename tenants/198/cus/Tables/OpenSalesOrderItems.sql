CREATE TABLE [cus].[OpenSalesOrderItems] (
    [SalesOrder] NVARCHAR(64) NULL,
    [SalesOrderItem] NVARCHAR(64) NULL,
    [Material] NVARCHAR(64) NULL,
    [PricingDate] DATETIME2 NULL,
    [RequestedQuantity] NVARCHAR(64) NULL,
    [RequestedQuantityUnit] NVARCHAR(64) NULL,
    [ItemGrossWeight] NVARCHAR(64) NULL,
    [ItemNetWeight] NVARCHAR(64) NULL,
    [ItemWeightUnit] NVARCHAR(64) NULL,
    [ItemVolume] NVARCHAR(64) NULL,
    [MaterialGroup] NVARCHAR(64) NULL,
    [ProductionPlant] NVARCHAR(64) NULL,
    [StorageLocation] NVARCHAR(64) NULL
);
