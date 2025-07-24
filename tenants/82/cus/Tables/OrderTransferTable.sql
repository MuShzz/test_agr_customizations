CREATE TABLE [cus].[OrderTransferTable] (
    [PurchTransfer] INT NOT NULL,
    [HeaderLine] INT NOT NULL,
    [OrderAccount] CHAR(10) NOT NULL,
    [InventLocationIdFrom] CHAR(10) NOT NULL,
    [InventLocationIdTo] CHAR(10) NOT NULL,
    [ItemId] CHAR(10) NOT NULL,
    [Qty] INT NOT NULL,
    [CreationDate] DATE NOT NULL,
    [Imported] BIT NULL,
    [OrderStatus] INT NOT NULL
);
