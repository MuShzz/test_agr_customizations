CREATE TABLE [cus].[ItemVendor] (
    [item] INT NOT NULL,
    [vendor] INT NOT NULL,
    [vendorcode] NVARCHAR(100) NULL,
    [predicteddays] INT NULL,
    [preferredvendor] NVARCHAR(1) NULL,
    [purchaseprice] DECIMAL(18,4) NULL,
    [vendorcost] DECIMAL(18,4) NULL,
    [vendorcostentered] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_ItemVendor] PRIMARY KEY (item,vendor)
);
