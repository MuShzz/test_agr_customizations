CREATE TABLE [cus].[InventoryStockTransferDetail] (
    [TransferCode] NVARCHAR(30) NOT NULL,
    [ItemCode] NVARCHAR(30) NOT NULL,
    [LineNum] INT NOT NULL,
    [LocationCodeSource] NVARCHAR(30) NOT NULL,
    [Quantity] DECIMAL(18,6) NULL,
    [LocationCodeDest] NVARCHAR(30) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryStockTransferDetail] PRIMARY KEY (ItemCode,LineNum,LocationCodeSource,TransferCode)
);
