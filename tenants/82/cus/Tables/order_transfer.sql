CREATE TABLE [cus].[order_transfer] (
    [orderId] INT NULL,
    [status] NVARCHAR(100) NULL,
    [locationNo] NVARCHAR(100) NULL,
    [locationName] NVARCHAR(100) NULL,
    [vendorNo] NVARCHAR(100) NULL,
    [vendorName] NVARCHAR(100) NULL,
    [orderType] NVARCHAR(100) NULL,
    [estimatedDeliveryDate] NVARCHAR(100) NULL,
    [createdAt] NVARCHAR(100) NULL,
    [itemNo] NVARCHAR(100) NULL,
    [itemName] NVARCHAR(100) NULL,
    [quantity] DECIMAL(18,4) NULL,
    [quantityInPurchaseUnits] DECIMAL(18,4) NULL,
    [estimatedDeliveryDateOrderLine] NVARCHAR(100) NULL
);
