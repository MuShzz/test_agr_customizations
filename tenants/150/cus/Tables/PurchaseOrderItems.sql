CREATE TABLE [cus].[PurchaseOrderItems] (
    [ID] BIGINT NOT NULL,
    [Number] NVARCHAR(100) NOT NULL,
    [$Product.Code] NVARCHAR(100) NULL,
    [$Quantity] DECIMAL(18,4) NULL,
    [$Product.Description] NVARCHAR(255) NULL,
    [$NetPrice] DECIMAL(18,4) NULL,
    [$TaxRate.Code] NVARCHAR(255) NULL,
    [$TaxRate.Description] NVARCHAR(255) NULL,
    [$DueDate] DATETIME2 NULL,
    [$QuantityOutstanding] DECIMAL(18,4) NULL,
    [$D_LineComment] NVARCHAR(255) NULL
);
