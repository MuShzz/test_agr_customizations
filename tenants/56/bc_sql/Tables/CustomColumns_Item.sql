CREATE TABLE [bc_sql_cus].[CustomColumns_Item] (
    [No_] NVARCHAR(20) NOT NULL,
    [Vendor No_] NVARCHAR(255) NOT NULL,
    [ABC Class] NVARCHAR(255) NOT NULL,
    [Item Category Code] NVARCHAR(255) NOT NULL,
    [Product Group Code] NVARCHAR(255) NOT NULL,
    [Item Stat Group] NVARCHAR(255) NOT NULL,
    [Search Description] NVARCHAR(255) NOT NULL,
    CONSTRAINT [pk_ItemCC] PRIMARY KEY (No_)
);
