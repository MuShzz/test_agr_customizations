CREATE TABLE [cus].[InventorySupplier] (
    [ItemCode] NVARCHAR(30) NOT NULL,
    [SupplierCode] NVARCHAR(30) NOT NULL,
    [WarehouseCode] NVARCHAR(30) NOT NULL,
    [UnitMeasureCode] NVARCHAR(30) NULL,
    [LeadTime] INT NULL,
    [PartCode] NVARCHAR(50) NULL,
    [Priority] INT NULL,
    [UsualQtyOrder] DECIMAL(18,6) NULL,
    [MOQ_C] DECIMAL(18,2) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventorySupplier] PRIMARY KEY (ItemCode,SupplierCode,WarehouseCode)
);
