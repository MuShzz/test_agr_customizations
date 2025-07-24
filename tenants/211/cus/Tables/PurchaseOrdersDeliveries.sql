CREATE TABLE [cus].[PurchaseOrdersDeliveries] (
    [id] NVARCHAR(255) NULL,
    [modified] DATETIME2 NULL,
    [created] DATETIME2 NULL,
    [isCounted] BIT NULL,
    [warehouseCode] NVARCHAR(255) NULL,
    [invoiceNumber] NVARCHAR(255) NULL,
    [estimatedTimeOfArrival] DATETIME2 NULL,
    [suppliers] NVARCHAR(255) NULL,
    [supplierIds] NVARCHAR(255) NULL,
    [deliveryStatus] NVARCHAR(255) NULL,
    [isAutoDeliveryStatusDisabled] BIT NULL,
    [orderType] NVARCHAR(255) NULL
);
