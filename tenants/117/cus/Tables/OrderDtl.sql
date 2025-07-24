CREATE TABLE [cus].[OrderDtl] (
    [OrderNum] INT NULL,
    [OrderLine] INT NULL,
    [PartNum] NVARCHAR(50) NULL,
    [NeedByDate] DATE NULL,
    [RequestDate] DATE NULL,
    [SellingQuantity] DECIMAL(18,4) NULL
);
