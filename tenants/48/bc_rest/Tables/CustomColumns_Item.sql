CREATE TABLE [bc_rest_cus].[CustomColumns_Item] (
    [No_] NVARCHAR(20) NOT NULL,
    [Vendor No_] NVARCHAR(20) NULL,
    [Vendor Item No_] NVARCHAR(50) NULL,
    [Level1] NVARCHAR(255) NULL,
    [Level2] NVARCHAR(255) NULL,
    [Level3] NVARCHAR(255) NULL,
    [Level4] NVARCHAR(255) NULL,
    CONSTRAINT [pk_ItemCC] PRIMARY KEY (No_)
);
