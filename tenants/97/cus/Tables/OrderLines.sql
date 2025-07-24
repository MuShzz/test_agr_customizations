CREATE TABLE [cus].[OrderLines] (
    [Id] INT IDENTITY(1,1) NOT NULL,
    [ItemNo] NVARCHAR(255) NOT NULL,
    [Qty] DECIMAL(18,4) NOT NULL,
    [Style] NVARCHAR(255) NULL,
    [Color] NVARCHAR(255) NULL,
    [Size] NVARCHAR(255) NULL,
    [OrderToLocationNo] NVARCHAR(255) NOT NULL,
    [OrderId] INT NOT NULL DEFAULT ((0)),
    [EstDelivDate] DATE NOT NULL,
    CONSTRAINT [FK_cus_OrderLines_Orders_OrderId] FOREIGN KEY (OrderId) REFERENCES [cus].[Orders] (Id) ON DELETE CASCADE,
    CONSTRAINT [PK_cus_OrderLines] PRIMARY KEY (Id)
);
