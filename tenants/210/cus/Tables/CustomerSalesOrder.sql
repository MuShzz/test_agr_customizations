CREATE TABLE [cus].[CustomerSalesOrder] (
    [SalesOrderCode] NVARCHAR(30) NOT NULL,
    [WarehouseCode] NVARCHAR(30) NULL,
    [Type] NVARCHAR(25) NULL,
    [OrderStatus] NVARCHAR(20) NULL,
    [IsVoided] BIT NULL,
    [BillToCode] NVARCHAR(30) NULL,
    [MaxoptraETA_C] NVARCHAR(50) NULL,
    [DeliveryDate_IUK] DATETIME NULL,
    [DelDateType_IUK] NVARCHAR(30) NULL,
    [PODate] SMALLDATETIME NULL,
    [DueDate] DATETIME NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_CustomerSalesOrder] PRIMARY KEY (SalesOrderCode)
);
