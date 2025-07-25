CREATE TABLE [cus].[StockItem] (
    [pkStockItemID] NVARCHAR(255) NULL,
    [ItemTitle] NVARCHAR(255) NULL,
    [ItemNumber] NVARCHAR(255) NULL,
    [ItemDescription] NVARCHAR(1000) NULL,
    [CreationDate] NVARCHAR(255) NULL,
    [bLogicalDelete] NVARCHAR(255) NULL,
    [RetailPrice] NVARCHAR(255) NULL,
    [CategoryId] NVARCHAR(255) NULL,
    [Weight] NVARCHAR(255) NULL,
    [PackageGroup] NVARCHAR(255) NULL,
    [BinRack] NVARCHAR(255) NULL,
    [rowguid] NVARCHAR(255) NULL,
    [PurchasePrice] NVARCHAR(255) NULL,
    [BarcodeNumber] NVARCHAR(255) NULL,
    [DimHeight] NVARCHAR(255) NULL,
    [DimWidth] NVARCHAR(255) NULL,
    [DimDepth] NVARCHAR(255) NULL,
    [ShippedSeparately] NVARCHAR(255) NULL,
    [TaxRate] NVARCHAR(255) NULL,
    [fkPostalService] NVARCHAR(255) NULL,
    [bContainsComposites] NVARCHAR(255) NULL,
    [ModifiedDate] NVARCHAR(255) NULL,
    [ModifiedUserName] NVARCHAR(255) NULL,
    [ModifyAction] NVARCHAR(255) NULL,
    [IsArchived] NVARCHAR(255) NULL,
    [isVariationGroup] NVARCHAR(255) NULL,
    [InventoryTrackingType] NVARCHAR(255) NULL,
    [SerialNumberScanRequired] NVARCHAR(255) NULL,
    [BatchNumberScanRequired] NVARCHAR(255) NULL,
    [StockItemIntId] NVARCHAR(255) NULL
);
