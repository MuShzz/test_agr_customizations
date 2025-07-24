CREATE TABLE [cus].[SalesHeader] (
    [Document Type] INT NOT NULL,
    [No_] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(10) NOT NULL,
    [Sell-to Customer No_] NVARCHAR(20) NOT NULL,
    [Requested Delivery Date] DATETIME NOT NULL,
    [Promised Delivery Date] DATETIME NOT NULL,
    [Status] INT NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_SalesHeader] PRIMARY KEY (Company,Document Type,No_)
);
