CREATE TABLE [cus].[SupplierPurchaseOrder] (
    [PurchaseOrderCode] NVARCHAR(30) NOT NULL,
    [PODate] SMALLDATETIME NULL,
    [Type] NVARCHAR(50) NULL,
    [OrderStatus] NVARCHAR(20) NULL,
    [IsProcessed] BIT NULL,
    [IsVoided] BIT NULL,
    [SupplierCode] NVARCHAR(30) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_SupplierPurchaseOrder] PRIMARY KEY (PurchaseOrderCode)
);
