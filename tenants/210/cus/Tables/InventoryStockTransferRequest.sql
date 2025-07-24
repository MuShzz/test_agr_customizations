CREATE TABLE [cus].[InventoryStockTransferRequest] (
    [TransferCode] NVARCHAR(30) NOT NULL,
    [TransferDate] DATETIME NULL,
    [WarehouseCodeSource] NVARCHAR(30) NULL,
    [WarehouseCodeRequest] NVARCHAR(30) NULL,
    [Status] NVARCHAR(30) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryStockTransferRequest] PRIMARY KEY (TransferCode)
);
