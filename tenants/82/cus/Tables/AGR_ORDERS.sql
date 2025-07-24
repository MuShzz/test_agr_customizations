CREATE TABLE [cus].[AGR_ORDERS] (
    [orderId] BIGINT NULL,
    [status] NVARCHAR(MAX) NULL,
    [locationNo] NVARCHAR(MAX) NULL,
    [locationName] NVARCHAR(MAX) NULL,
    [vendorNo] NVARCHAR(MAX) NULL,
    [vendorName] NVARCHAR(MAX) NULL,
    [orderType] NVARCHAR(MAX) NULL,
    [estimatedDeliveryDate] NVARCHAR(MAX) NULL,
    [createdAt] NVARCHAR(MAX) NULL,
    [itemNo] NVARCHAR(MAX) NULL,
    [itemName] NVARCHAR(MAX) NULL,
    [quantity] DECIMAL(38,18) NULL,
    [quantityInPurchaseUnits] DECIMAL(38,18) NULL,
    [estimatedDeliveryDateOrderLine] NVARCHAR(MAX) NULL
);
