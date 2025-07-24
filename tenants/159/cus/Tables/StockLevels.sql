CREATE TABLE [cus].[StockLevels] (
    [fkStockItemId] NVARCHAR(255) NULL,
    [fkStockLocationId] NVARCHAR(255) NULL,
    [Quantity] NVARCHAR(255) NULL,
    [OnOrder] NVARCHAR(255) NULL,
    [CurrentStockValue] NVARCHAR(255) NULL,
    [MinimumLevel] NVARCHAR(255) NULL,
    [AutoAdjust] NVARCHAR(255) NULL,
    [LastUpdateDate] NVARCHAR(255) NULL,
    [LastUpdateOperation] NVARCHAR(255) NULL,
    [rowid] NVARCHAR(255) NULL,
    [PendingUpdate] NVARCHAR(255) NULL,
    [InOrderBook] NVARCHAR(255) NULL,
    [JIT] NVARCHAR(255) NULL
);
