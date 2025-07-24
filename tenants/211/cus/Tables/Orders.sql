CREATE TABLE [cus].[Orders] (
    [id] NVARCHAR(50) NULL,
    [orderNumber] NVARCHAR(50) NULL,
    [customerId] NVARCHAR(50) NULL,
    [customerNumber] NVARCHAR(50) NULL,
    [customerName] NVARCHAR(255) NULL,
    [marketId] NVARCHAR(50) NULL,
    [$orderForm] NVARCHAR(MAX) NULL,
    [status] NVARCHAR(50) NULL,
    [remainingPayment] DECIMAL(18,2) NULL,
    [modified] DATETIME2 NULL,
    [created] DATETIME2 NULL,
    [requestedDeliveryDate] DATETIME2 NULL
);
