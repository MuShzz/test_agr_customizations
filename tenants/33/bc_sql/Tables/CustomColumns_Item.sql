CREATE TABLE [bc_sql_cus].[CustomColumns_Item] (
    [No_] NVARCHAR(20) NOT NULL,
    [Vendor No_] NVARCHAR(20) NULL,
    [Vendor Item No_] NVARCHAR(50) NULL,
    [LSC Item Family Code] NVARCHAR(50) NOT NULL,
    CONSTRAINT [pk_ItemCC] PRIMARY KEY (No_)
);
