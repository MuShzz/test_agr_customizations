CREATE TABLE [bc_sql_cus].[ItemVendor] (
    [Vendor No_] NVARCHAR(20) NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    [Variant Code] NVARCHAR(10) NOT NULL,
    [Lead Time Calculation] NVARCHAR(32) NULL,
    [Vendor Item No_] NVARCHAR(50) NOT NULL,
    [company] CHAR(3) NOT NULL DEFAULT (''),
    CONSTRAINT [pk_bc_sql_cus_ItemVendor] PRIMARY KEY (Item No_,Variant Code,Vendor No_)
);
