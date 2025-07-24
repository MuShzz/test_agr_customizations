CREATE TABLE [cus].[InventoryAdjustmentLine] (
    [TxnID] NVARCHAR(36) NULL,
    [TimeCreated] DATETIME2 NULL,
    [TimeModified] DATETIME2 NULL,
    [EditSequence] NVARCHAR(16) NULL,
    [TxnNumber] INT NULL,
    [TxnDate] DATETIME2 NULL,
    [RefNumber] NVARCHAR(11) NULL,
    [InventoryAdjustmentSeqNo] INT NULL,
    [InventoryAdjustmentLineTxnLineID] NVARCHAR(36) NULL,
    [InventoryAdjustmentLineItemRefListID] NVARCHAR(36) NULL,
    [InventoryAdjustmentLineItemRefFullName] NVARCHAR(159) NULL,
    [InventoryAdjustmentLineQuantityDifference] DECIMAL(16,5) NULL,
    [InventorySiteRefListID] NVARCHAR(36) NULL,
    [InventorySiteRefFullName] NVARCHAR(31) NULL,
    [FQPrimaryKey] NVARCHAR(73) NULL
);
