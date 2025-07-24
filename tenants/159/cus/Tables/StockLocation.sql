CREATE TABLE [cus].[StockLocation] (
    [pkStockLocationId] NVARCHAR(255) NULL,
    [Location] NVARCHAR(255) NULL,
    [Address1] NVARCHAR(255) NULL,
    [Address2] NVARCHAR(255) NULL,
    [City] NVARCHAR(255) NULL,
    [County] NVARCHAR(255) NULL,
    [Country] NVARCHAR(255) NULL,
    [ZipCode] NVARCHAR(255) NULL,
    [bLogicalDelete] NVARCHAR(255) NULL,
    [IsNotTrackable] NVARCHAR(255) NULL,
    [LocationTag] NVARCHAR(255) NULL,
    [IsFulfillmentCenter] NVARCHAR(255) NULL,
    [CountInOrderUntilAcknowledgement] NVARCHAR(255) NULL,
    [FulfilmentCenterDeductStockWhenProcessed] NVARCHAR(255) NULL,
    [IsWarehouseManaged] NVARCHAR(255) NULL,
    [StockLocationIntId] NVARCHAR(255) NULL
);
