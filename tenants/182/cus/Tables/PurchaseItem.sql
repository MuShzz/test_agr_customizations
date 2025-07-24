CREATE TABLE [cus].[PurchaseItem] (
    [pkPurchaseItemId] NVARCHAR(255) NULL,
    [fkPurchasId] NVARCHAR(255) NULL,
    [fkStockItemId] NVARCHAR(255) NULL,
    [Quantity] NVARCHAR(255) NULL,
    [Cost] NVARCHAR(255) NULL,
    [Delivered] NVARCHAR(255) NULL,
    [TaxRate] NVARCHAR(255) NULL,
    [Tax] NVARCHAR(255) NULL,
    [PackQuantity] NVARCHAR(255) NULL,
    [PackSize] NVARCHAR(255) NULL,
    [SortOrder] NVARCHAR(255) NULL
);
