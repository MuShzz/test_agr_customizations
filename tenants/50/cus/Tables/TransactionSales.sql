CREATE TABLE [cus].[TransactionSales] (
    [uniquekey] BIGINT NOT NULL,
    [entity] INT NULL,
    [transactionid] INT NULL,
    [item] INT NULL,
    [location] INT NULL,
    [trandate] NVARCHAR(100) NULL,
    [quantity] DECIMAL(18,4) NULL,
    [tranid] NVARCHAR(100) NULL,
    [type] NVARCHAR(100) NULL,
    [vendor] INT NULL,
    [isinventoryaffecting] NVARCHAR(1) NULL,
    [voided] NVARCHAR(1) NULL,
    CONSTRAINT [PK_TransactionSales] PRIMARY KEY (uniquekey)
);
