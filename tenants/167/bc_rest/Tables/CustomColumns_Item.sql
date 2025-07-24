CREATE TABLE [bc_rest_cus].[CustomColumns_Item] (
    [ItemNo] NVARCHAR(20) NOT NULL,
    [Discontinued] BIT NULL,
    [ItemClassification] NVARCHAR(20) NULL,
    [ProductGroupCode] NVARCHAR(20) NULL,
    CONSTRAINT [pk_ItemCC] PRIMARY KEY (ItemNo)
);
