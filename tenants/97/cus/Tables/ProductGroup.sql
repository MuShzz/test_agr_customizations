CREATE TABLE [cus].[ProductGroup] (
    [Item Category Code] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(10) NOT NULL,
    [Description] NVARCHAR(50) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_ProductGroup] PRIMARY KEY (Code,Company,Item Category Code)
);
