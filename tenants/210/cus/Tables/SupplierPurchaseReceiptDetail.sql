CREATE TABLE [cus].[SupplierPurchaseReceiptDetail] (
    [PurchaseReceiptCode] NVARCHAR(30) NOT NULL,
    [ItemCode] NVARCHAR(30) NOT NULL,
    [LineNum] INT NOT NULL,
    [WarehouseCode] NVARCHAR(30) NULL,
    [DueDate] SMALLDATETIME NULL,
    [QuantityOrdered] DECIMAL(18,6) NULL,
    [QuantityReceived] DECIMAL(18,6) NULL,
    [OriginalDocumentCode] NVARCHAR(30) NULL,
    [UnitMeasureQty] DECIMAL(18,6) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_SupplierPurchaseReceiptDetail] PRIMARY KEY (ItemCode,LineNum,PurchaseReceiptCode)
);
