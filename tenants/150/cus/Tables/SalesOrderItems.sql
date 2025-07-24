CREATE TABLE [cus].[SalesOrderItems] (
    [ID] BIGINT NOT NULL,
    [Number] NVARCHAR(50) NOT NULL,
    [$Product.Code] NVARCHAR(255) NULL,
    [$Product.Description] NVARCHAR(255) NULL,
    [$QuantityOutstanding] DECIMAL(18,4) NULL,
    [$CALC_AGRClosed] BIT NULL,
    [$DueDate] DATETIME2 NULL
);
