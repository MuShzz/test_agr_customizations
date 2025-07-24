CREATE TABLE [cus].[InventoryStockTransferRequestDetail] (
    [TransferCode] NVARCHAR(30) NOT NULL,
    [ItemCode] NVARCHAR(30) NOT NULL,
    [LineNum] INT NOT NULL,
    [LocationCodeSource] NVARCHAR(30) NOT NULL,
    [LocationCodeDest] NVARCHAR(30) NULL,
    [Quantity] DECIMAL(18,6) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryStockTransferRequestDetail] PRIMARY KEY (ItemCode,LineNum,LocationCodeSource,TransferCode)
);
