CREATE TABLE [cus].[InventoryStockTotal] (
    [ItemCode] NVARCHAR(30) NOT NULL,
    [WarehouseCode] NVARCHAR(30) NOT NULL,
    [UnitsInStock] DECIMAL(18,6) NULL,
    [ReorderPoint] DECIMAL(18,6) NULL,
    [MinLevel] DECIMAL(18,6) NULL,
    [MaxLevel] DECIMAL(18,6) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryStockTotal] PRIMARY KEY (ItemCode,WarehouseCode)
);
