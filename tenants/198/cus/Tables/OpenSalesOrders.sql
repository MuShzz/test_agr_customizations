CREATE TABLE [cus].[OpenSalesOrders] (
    [SalesOrder] INT NULL,
    [SalesOrderType] NVARCHAR(128) NULL,
    [SalesOrganization] SMALLINT NULL,
    [CreationDate] DATETIME2 NULL,
    [LastChangeDateTime] DATETIME2 NULL,
    [SoldToParty] INT NULL,
    [TotalNetAmount] FLOAT(53) NULL,
    [TransactionCurrency] NVARCHAR(128) NULL,
    [RequestedDeliveryDate] DATETIME2 NULL
);
