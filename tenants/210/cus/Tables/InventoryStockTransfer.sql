CREATE TABLE [cus].[InventoryStockTransfer] (
    [TransferCode] NVARCHAR(30) NOT NULL,
    [TransferDate] DATETIME NULL,
    [WarehouseCodeSource] NVARCHAR(30) NULL,
    [WarehouseCodeDest] NVARCHAR(30) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryStockTransfer] PRIMARY KEY (TransferCode)
);
