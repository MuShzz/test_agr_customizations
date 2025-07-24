CREATE TABLE [cus].[CustomerInvoice] (
    [InvoiceCode] NVARCHAR(30) NOT NULL,
    [BillToCode] NVARCHAR(30) NULL,
    [WarehouseCode] NVARCHAR(30) NULL,
    [InvoiceDate] SMALLDATETIME NULL,
    [Type] NVARCHAR(25) NULL,
    [OrderStatus] NVARCHAR(20) NULL,
    [IsVoided] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_CustomerInvoice] PRIMARY KEY (InvoiceCode)
);
