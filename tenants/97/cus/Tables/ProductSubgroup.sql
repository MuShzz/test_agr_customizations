CREATE TABLE [cus].[ProductSubgroup] (
    [Item Category Code] NVARCHAR(20) NULL,
    [Product Group Code] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(255) NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_ProductSubgroup] PRIMARY KEY (Code,Company,Product Group Code)
);
