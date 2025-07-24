CREATE TABLE [cus].[InventoryItem] (
    [ItemCode] NVARCHAR(30) NOT NULL,
    [ItemName] NVARCHAR(100) NULL,
    [ItemType] NVARCHAR(25) NULL,
    [Status] NVARCHAR(20) NULL,
    [MinPurchaseQty] SMALLINT NULL,
    [LeadTime] SMALLINT NULL,
    [IsSpecialOrder] BIT NULL,
    [StandardCost] DECIMAL(18,6) NULL,
    [StandardCostRate] DECIMAL(18,6) NULL,
    [UsageAdjustmentQty_C] DECIMAL(18,1) NULL,
    [IsIntendToStockItem_C] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryItem] PRIMARY KEY (ItemCode)
);
