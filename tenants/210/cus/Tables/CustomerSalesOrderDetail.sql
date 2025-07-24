CREATE TABLE [cus].[CustomerSalesOrderDetail] (
    [SalesOrderCode] NVARCHAR(30) NOT NULL,
    [ItemCode] NVARCHAR(30) NOT NULL,
    [LineNum] INT NOT NULL,
    [WarehouseCode] NVARCHAR(30) NULL,
    [QuantityOrdered] DECIMAL(18,6) NULL,
    [UnitMeasureQty] DECIMAL(18,6) NULL,
    [DueDate] SMALLDATETIME NULL,
    [RevisedDueDate] SMALLDATETIME NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_CustomerSalesOrderDetail] PRIMARY KEY (ItemCode,LineNum,SalesOrderCode)
);
