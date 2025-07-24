CREATE TABLE [cus].[SupplierPurchaseOrderDetail] (
    [PurchaseOrderCode] NVARCHAR(30) NOT NULL,
    [ItemCode] NVARCHAR(30) NOT NULL,
    [LineNum] INT NOT NULL,
    [WarehouseCode] NVARCHAR(30) NULL,
    [DueDate] SMALLDATETIME NULL,
    [QuantityOrdered] DECIMAL(18,6) NULL,
    [QuantityReceived] DECIMAL(18,6) NULL,
    [UnitMeasureQty] DECIMAL(18,6) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_SupplierPurchaseOrderDetail] PRIMARY KEY (ItemCode,LineNum,PurchaseOrderCode)
);
