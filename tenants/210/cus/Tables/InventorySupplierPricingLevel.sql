CREATE TABLE [cus].[InventorySupplierPricingLevel] (
    [ItemCode] NVARCHAR(30) NOT NULL,
    [SupplierCode] NVARCHAR(30) NOT NULL,
    [LineNum] INT NOT NULL,
    [UnitMeasureCode] NVARCHAR(30) NOT NULL,
    [DateFrom] DATETIME NULL,
    [DateTo] DATETIME NULL,
    [MinQuantity] DECIMAL(18,6) NULL,
    [MaxQuantity] DECIMAL(18,6) NULL,
    [BaseCost] DECIMAL(18,6) NULL,
    [IsPriority] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventorySupplierPricingLevel] PRIMARY KEY (ItemCode,LineNum,SupplierCode,UnitMeasureCode)
);
