CREATE TABLE [cus].[BuildAssemblyComponentItemLine] (
    [TxnID] NVARCHAR(36) NULL,
    [TimeCreated] DATETIME2 NULL,
    [TimeModified] DATETIME2 NULL,
    [EditSequence] NVARCHAR(16) NULL,
    [TxnNumber] INT NULL,
    [ItemInventoryAssemblyRefListID] NVARCHAR(36) NULL,
    [ItemInventoryAssemblyRefFullName] NVARCHAR(159) NULL,
    [InventorySiteRefListID] NVARCHAR(36) NULL,
    [InventorySiteRefFullName] NVARCHAR(31) NULL,
    [InventorySiteLocationRefListID] NVARCHAR(36) NULL,
    [InventorySiteLocationRefFullName] NVARCHAR(31) NULL,
    [SerialNumber] NVARCHAR(MAX) NULL,
    [LotNumber] NVARCHAR(40) NULL,
    [TxnDate] DATETIME2 NULL,
    [TxnDateMacro] NVARCHAR(23) NULL,
    [RefNumber] NVARCHAR(11) NULL,
    [Memo] NVARCHAR(MAX) NULL,
    [IsPending] BIT NULL,
    [QuantityToBuild] DECIMAL(16,5) NULL,
    [QuantityCanBuild] DECIMAL(16,5) NULL,
    [QuantityOnHand] DECIMAL(16,5) NULL,
    [QuantityOnSalesOrder] DECIMAL(16,5) NULL,
    [MarkPendingIfRequired] BIT NULL,
    [RemovePending] BIT NULL,
    [ComponentItemLineSeqNo] INT NULL,
    [ComponentItemLineItemRefListID] NVARCHAR(36) NULL,
    [ComponentItemLineItemRefFullName] NVARCHAR(159) NULL,
    [ComponentItemLineInventorySiteRefListID] NVARCHAR(36) NULL,
    [ComponentItemLineInventorySiteRefFullName] NVARCHAR(31) NULL,
    [ComponentItemLineInventorySiteLocationRefListID] NVARCHAR(36) NULL,
    [ComponentItemLineInventorySiteLocationRefFullName] NVARCHAR(31) NULL,
    [ComponentItemLineSerialNumber] NVARCHAR(MAX) NULL,
    [ComponentItemLineLotNumber] NVARCHAR(40) NULL,
    [ComponentItemLineDesc] NVARCHAR(MAX) NULL,
    [ComponentItemLineQuantityOnHand] DECIMAL(16,5) NULL,
    [ComponentItemLineQuantityNeeded] DECIMAL(16,5) NULL,
    [FQPrimaryKey] NVARCHAR(110) NULL
);
