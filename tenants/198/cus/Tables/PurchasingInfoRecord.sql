CREATE TABLE [cus].[PurchasingInfoRecord] (
    [PurchasingInfoRecord] NVARCHAR(128) NULL,
    [Supplier] NVARCHAR(128) NULL,
    [Material] NVARCHAR(128) NULL,
    [CreationDate] DATETIME2 NULL,
    [SupplierMaterialNumber] NVARCHAR(128) NULL,
    [BaseUnit] NVARCHAR(128) NULL,
    [OrderItemQtyToBaseQtyNmrtr] NVARCHAR(128) NULL,
    [OrderItemQtyToBaseQtyDnmntr] NVARCHAR(128) NULL,
    [IsRegularSupplier] BIT NULL
);
