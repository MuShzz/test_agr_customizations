CREATE TABLE [cus].[ItemLocation] (
    [fkStockItemId] NVARCHAR(255) NOT NULL,
    [fkLocationId] NVARCHAR(255) NOT NULL,
    [BinRackNumber] NVARCHAR(64) NOT NULL,
    [rowid] NVARCHAR(255) NOT NULL
);
