CREATE TABLE [cus].[order_transfer] (
    [orderId] INT NULL,
    [status] NVARCHAR(255) NULL,
    [locationNo] NVARCHAR(255) NULL,
    [locationName] NVARCHAR(255) NULL,
    [vendorNo] NVARCHAR(255) NULL,
    [vendorName] NVARCHAR(255) NULL,
    [orderType] NVARCHAR(255) NULL,
    [estimatedDeliveryDate] NVARCHAR(1255) NULL,
    [createdAt] NVARCHAR(255) NULL,
    [itemNo] NVARCHAR(255) NULL,
    [itemName] NVARCHAR(512) NULL,
    [quantity] NVARCHAR(22) NULL,
    [quantityInPurchaseUnits] NVARCHAR(22) NULL,
    [estimatedDeliveryDateOrderLine] NVARCHAR(255) NULL
);
