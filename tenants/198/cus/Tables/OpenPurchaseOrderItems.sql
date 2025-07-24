CREATE TABLE [cus].[OpenPurchaseOrderItems] (
    [PurchaseOrder] NVARCHAR(128) NULL,
    [PurchaseOrderItem] NVARCHAR(128) NULL,
    [PurchaseOrderItemText] NVARCHAR(128) NULL,
    [Plant] NVARCHAR(128) NULL,
    [StorageLocation] NVARCHAR(128) NULL,
    [MaterialGroup] NVARCHAR(128) NULL,
    [OrderQuantity] NVARCHAR(128) NULL,
    [PurchaseOrderQuantityUnit] NVARCHAR(128) NULL,
    [OrderPriceUnit] NVARCHAR(128) NULL,
    [OrderPriceUnitToOrderUnitNmrtr] NVARCHAR(128) NULL,
    [OrdPriceUnitToOrderUnitDnmntr] NVARCHAR(128) NULL,
    [PurchaseOrderItemCategory] NVARCHAR(128) NULL,
    [ItemNetWeight] NVARCHAR(128) NULL,
    [ItemWeightUnit] NVARCHAR(128) NULL,
    [ItemVolume] NVARCHAR(128) NULL,
    [Material] NVARCHAR(128) NULL,
    [IsReturnsItem] BIT NULL
);
