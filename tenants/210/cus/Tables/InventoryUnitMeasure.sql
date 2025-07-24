CREATE TABLE [cus].[InventoryUnitMeasure] (
    [ItemCode] NVARCHAR(30) NOT NULL,
    [UnitMeasureCode] NVARCHAR(30) NOT NULL,
    [UnitMeasureQty] DECIMAL(18,6) NULL,
    [WeightInKilograms] DECIMAL(18,6) NULL,
    [VolumeInCubicMeters] DECIMAL(18,6) NULL,
    [IsDefault] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryUnitMeasure] PRIMARY KEY (ItemCode,UnitMeasureCode)
);
