CREATE TABLE [cus].[InventoryAdjustmentDetail] (
    [AdjustmentCode] NVARCHAR(30) NOT NULL,
    [ItemCode] NVARCHAR(30) NOT NULL,
    [WarehouseCode] NVARCHAR(30) NOT NULL,
    [UnitMeasureCode] NVARCHAR(30) NOT NULL,
    [LocationCode] NVARCHAR(30) NOT NULL,
    [LineNum] INT NOT NULL,
    [Quantity] DECIMAL(18,6) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryAdjustmentDetail] PRIMARY KEY (AdjustmentCode,ItemCode,LineNum,LocationCode,UnitMeasureCode,WarehouseCode)
);
