CREATE TABLE [cus].[PurchaseHeader] (
    [Document Type] INT NOT NULL,
    [No_] NVARCHAR(20) NOT NULL,
    [Buy-from Vendor No_] NVARCHAR(20) NOT NULL,
    [Order Date] DATETIME NOT NULL,
    [Posting Date] DATETIME NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_PurchaseHeader] PRIMARY KEY (Company,Document Type,No_)
);
