CREATE TABLE [cus].[SalesInvoiceItems] (
    [ID] BIGINT NOT NULL,
    [Number] NVARCHAR(50) NOT NULL,
    [Date] DATE NULL,
    [$ID] BIGINT NOT NULL,
    [$Product.Code] NVARCHAR(255) NULL,
    [$Product.Description] NVARCHAR(255) NULL,
    [$Quantity] DECIMAL(18,4) NULL
);
