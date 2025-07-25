CREATE TABLE [dk_cus].[import_transactions_mendes] (
    [ObjectDate] NVARCHAR(500) NULL,
    [Created] NVARCHAR(500) NULL,
    [ID] BIGINT NULL,
    [CreatedBy] NVARCHAR(500) NULL,
    [Modified] NVARCHAR(500) NULL,
    [Origin] BIGINT NULL,
    [HeadId] BIGINT NULL,
    [Sequence] BIGINT NULL,
    [ItemCode] NVARCHAR(500) NULL,
    [Warehouse] NVARCHAR(500) NULL,
    [Customer] NVARCHAR(500) NULL,
    [TransactionCode] BIGINT NULL,
    [JournalDate] NVARCHAR(500) NULL,
    [JournalType] BIGINT NULL,
    [Quantity] REAL NULL,
    [PurchasePrice] REAL NULL,
    [CurrencyCode] NVARCHAR(500) NULL,
    [Exchange] REAL NULL,
    [CostPrice] REAL NULL,
    [CostAmount] REAL NULL,
    [SalesAmount] REAL NULL,
    [InventOnHand] REAL NULL,
    [Text] NVARCHAR(500) NULL,
    [NetWeight] REAL NULL,
    [UnitVolume] REAL NULL,
    [NumberOfPackages] REAL NULL,
    [CountedQuantity] REAL NULL,
    [VendorPrice] REAL NULL,
    [VendorDiscount] REAL NULL,
    [Fabrication] BIGINT NULL,
    [TypeOf] BIGINT NULL,
    [PurchaseAmount] REAL NULL,
    [PoBatchId] BIGINT NULL
);
