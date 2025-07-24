CREATE TABLE [nav_cus].[PendingSalesOrderLine] (
    [Order No_] NVARCHAR(20) NOT NULL,
    [Line No_] INT NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    [Quantity] DECIMAL(38,20) NOT NULL,
    [Released] TINYINT NOT NULL,
    [Variant Code] NVARCHAR(50) NULL,
    CONSTRAINT [pk_PendingSalesOrderLine] PRIMARY KEY (Item No_,Line No_,Order No_)
);
