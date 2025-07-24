CREATE TABLE [cus].[ItemLedgerEntry] (
    [Entry No_] INT NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    [Posting Date] DATETIME2 NOT NULL,
    [Entry Type] INT NOT NULL,
    [Location Code] NVARCHAR(10) NOT NULL,
    [Quantity] DECIMAL(38,20) NOT NULL,
    [Remaining Quantity] DECIMAL(38,20) NOT NULL,
    [Invoiced Quantity] DECIMAL(38,20) NOT NULL,
    [Qty_ per Unit of Measure] DECIMAL(38,20) NOT NULL,
    [Unit of Measure Code] NVARCHAR(10) NOT NULL,
    [Variant Code] NVARCHAR(10) NOT NULL,
    [Source No_] NVARCHAR(20) NOT NULL,
    [Document No_] NVARCHAR(20) NOT NULL,
    [Expiration Date] DATETIME2 NULL,
    [Lot No_] NVARCHAR(50) NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_ItemLedgerEntry] PRIMARY KEY (Company,Entry No_)
);
