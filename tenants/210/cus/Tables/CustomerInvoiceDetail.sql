CREATE TABLE [cus].[CustomerInvoiceDetail] (
    [InvoiceCode] NVARCHAR(30) NOT NULL,
    [ItemCode] NVARCHAR(30) NOT NULL,
    [LineNum] INT NOT NULL,
    [WarehouseCode] NVARCHAR(30) NULL,
    [QuantityShipped] DECIMAL(18,6) NULL,
    [UnitMeasureQty] DECIMAL(18,6) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_CustomerInvoiceDetail] PRIMARY KEY (InvoiceCode,ItemCode,LineNum)
);
