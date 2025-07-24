CREATE TABLE [nav_cus].[SalesLine] (
    [Document Type] INT NOT NULL,
    [Document No_] NVARCHAR(40) NOT NULL,
    [Line No_] INT NOT NULL,
    [Type] INT NOT NULL,
    [No_] NVARCHAR(40) NOT NULL,
    [Location Code] NVARCHAR(20) NOT NULL,
    [Quantity] NVARCHAR(500) NOT NULL,
    [Outstanding Qty_ (Base)] NVARCHAR(500) NOT NULL,
    [Shipment Date] DATETIME NOT NULL,
    [Variant Code] NVARCHAR(20) NULL,
    [Drop Shipment] TINYINT NOT NULL,
    CONSTRAINT [pk_cus_SalesLine2] PRIMARY KEY (Document No_,Document Type,Line No_)
);
