CREATE TABLE [cus].[SalesInvoice] (
    [ID] BIGINT NOT NULL,
    [Number] NVARCHAR(50) NOT NULL,
    [Date] DATETIME2 NULL,
    [Branch.Code] NVARCHAR(255) NULL,
    [Branch.Description] NVARCHAR(255) NULL,
    [$Items] NVARCHAR(MAX) NULL,
    [DeliveryAccount.Code] NVARCHAR(50) NULL,
    [DeliveryAccount.Name] NVARCHAR(255) NULL,
    [UpdatedOn] DATETIME2 NULL,
    [CreatedOn] DATETIME2 NULL
);
