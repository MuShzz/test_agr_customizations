CREATE TABLE [cus].[item_variant] (
    [Code] VARCHAR(10) NOT NULL,
    [ItemNo] VARCHAR(20) NOT NULL,
    [Description] VARCHAR(100) NOT NULL,
    [Description2] VARCHAR(50) NOT NULL,
    [ItemId] VARCHAR(50) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_item_variant] PRIMARY KEY (Code,Company,ItemNo)
);
