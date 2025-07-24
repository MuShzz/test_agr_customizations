CREATE TABLE [cus].[InventoryAdjustment] (
    [AdjustmentCode] NVARCHAR(30) NOT NULL,
    [AdjustmentType] NVARCHAR(10) NULL,
    [TransactionType] NVARCHAR(50) NULL,
    [TransactionDate] SMALLDATETIME NULL,
    [IsVoided] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryAdjustment] PRIMARY KEY (AdjustmentCode)
);
