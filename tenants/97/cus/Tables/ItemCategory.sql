CREATE TABLE [cus].[ItemCategory] (
    [Code] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(50) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_ItemCategory] PRIMARY KEY (Code,Company)
);
