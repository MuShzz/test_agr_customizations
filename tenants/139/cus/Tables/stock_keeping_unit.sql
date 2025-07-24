CREATE TABLE [cus].[stock_keeping_unit] (
    [ItemNo] NVARCHAR(20) NOT NULL,
    [LocationCode] NVARCHAR(10) NOT NULL,
    [UnitCost] DECIMAL(38,20) NOT NULL,
    [ReplenishmentSystem] NVARCHAR(20) NOT NULL,
    [TransferfromCode] NVARCHAR(10) NOT NULL,
    [VariantCode] NVARCHAR(10) NOT NULL,
    [LeadTimeCalculation] NVARCHAR(32) NOT NULL,
    [MinimumOrderQuantity] DECIMAL(18,4) NOT NULL,
    [OrderMultiple] DECIMAL(18,4) NOT NULL,
    [ReorderPoint] DECIMAL(38,20) NOT NULL,
    [MaximumInventory] DECIMAL(38,20) NOT NULL,
    [VendorNo] NVARCHAR(20) NOT NULL,
    [SafetyStockQuantity] DECIMAL(38,20) NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [pk_cus_stock_keeping_unit] PRIMARY KEY (Company,ItemNo,LocationCode)
);
