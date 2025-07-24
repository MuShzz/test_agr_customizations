CREATE TABLE [nav_cus].[OverrideRawData_Item] (
    [No_] NVARCHAR(20) NOT NULL,
    [Vendor No_] NVARCHAR(20) NULL,
    [Vendor Item No_] NVARCHAR(50) NULL,
    [Product Status] INT NULL,
    CONSTRAINT [pk_ItemOR] PRIMARY KEY (No_)
);
