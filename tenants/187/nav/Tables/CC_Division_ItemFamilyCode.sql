CREATE TABLE [nav_cus].[CC_Division_ItemFamilyCode] (
    [No_] NVARCHAR(20) NOT NULL,
    [Vendor No_] NVARCHAR(20) NULL,
    [Vendor Item No_] NVARCHAR(50) NULL,
    [Division Code] NVARCHAR(20) NULL,
    [Item Family Code] NVARCHAR(50) NULL,
    CONSTRAINT [pk_Item_NO] PRIMARY KEY (No_)
);
