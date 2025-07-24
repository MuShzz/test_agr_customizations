CREATE TABLE [cus].[ItemVariant] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(10) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [Description 2] NVARCHAR(50) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_ItemVariant] PRIMARY KEY (Code,Company,Item No_)
);
