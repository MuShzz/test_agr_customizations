CREATE TABLE [cus].[StockItem_ExtendedProperties] (
    [pkRowId] NVARCHAR(255) NULL,
    [fkStockItemId] NVARCHAR(255) NULL,
    [ProperyName] NVARCHAR(MAX) NULL,
    [ProperyValue] NVARCHAR(MAX) NULL,
    [ProperyType] NVARCHAR(MAX) NULL,
    [UserDefined] NVARCHAR(255) NULL,
    [fkParentRowId] NVARCHAR(255) NULL,
    [ModifiedDate] NVARCHAR(255) NULL,
    [ModifiedUserName] NVARCHAR(255) NULL
);
