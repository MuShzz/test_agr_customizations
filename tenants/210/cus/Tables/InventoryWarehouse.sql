CREATE TABLE [cus].[InventoryWarehouse] (
    [WarehouseCode] NVARCHAR(30) NOT NULL,
    [WarehouseDescription] NVARCHAR(500) NULL,
    [IsActive] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryWarehouse] PRIMARY KEY (WarehouseCode)
);
