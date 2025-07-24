CREATE TABLE [cus].[Orders] (
    [Id] INT NOT NULL,
    [OrderFromLocationNo] NVARCHAR(255) NOT NULL,
    [OrderToLocationNo] NVARCHAR(255) NOT NULL,
    [EstDelivDate] DATE NOT NULL,
    [OrderType] NVARCHAR(8) NOT NULL,
    [Status] INT NOT NULL DEFAULT ((1)),
    [StatusString] NVARCHAR(255) NOT NULL,
    CONSTRAINT [PK_cus_Orders] PRIMARY KEY (Id)
);
