CREATE TABLE [cus].[StockChange] (
    [rowid] NVARCHAR(255) NULL,
    [fkStockItemId] NVARCHAR(255) NULL,
    [fkStockLocationId] NVARCHAR(255) NULL,
    [StockChangeDateTime] NVARCHAR(255) NULL,
    [StockNow] NVARCHAR(255) NULL,
    [StockValue] NVARCHAR(255) NULL,
    [ChangeSource] NVARCHAR(255) NULL,
    [ChangeQty] NVARCHAR(255) NULL,
    [ChangeValue] NVARCHAR(255) NULL
);
