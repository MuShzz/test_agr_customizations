CREATE TABLE [nav_cus].[CustomColumns_Item] (
    [No_] NVARCHAR(20) NOT NULL,
    [Shelf No_] NVARCHAR(255) NOT NULL,
    [Brand] NVARCHAR(255) NOT NULL,
    [Item Status] NVARCHAR(255) NOT NULL,
    [Inventory Posting Group] NVARCHAR(MAX) NULL,
    CONSTRAINT [PK_CustomColumns_Item] PRIMARY KEY (No_)
);
