CREATE TABLE [cus].[SupplierPurchaseReceipt] (
    [PurchaseReceiptCode] NVARCHAR(30) NOT NULL,
    [PRDate] SMALLDATETIME NULL,
    [SupplierCode] NVARCHAR(30) NULL,
    [Type] NVARCHAR(50) NULL,
    [OrderStatus] NVARCHAR(20) NULL,
    [IsVoided] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_SupplierPurchaseReceipt] PRIMARY KEY (PurchaseReceiptCode)
);
