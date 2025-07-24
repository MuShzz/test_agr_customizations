CREATE TABLE [bc_sql_cus].[SalesLine_WePet] (
    [Document Type] INT NOT NULL,
    [Document No_] NVARCHAR(20) NOT NULL,
    [Line No_] INT NOT NULL,
    [Type] INT NOT NULL,
    [No_] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(10) NOT NULL,
    [Quantity] DECIMAL(38,20) NOT NULL,
    [Outstanding Qty_ (Base)] DECIMAL(38,20) NOT NULL,
    [Shipment Date] DATETIME NOT NULL,
    [Variant Code] NVARCHAR(10) NULL,
    [Drop Shipment] TINYINT NOT NULL,
    [company] CHAR(3) NOT NULL DEFAULT (''),
    CONSTRAINT [pk_bc_sql_cus_SalesLine_WePet] PRIMARY KEY (company,Document No_,Document Type,Line No_)
);
