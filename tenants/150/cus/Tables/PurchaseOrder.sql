CREATE TABLE [cus].[PurchaseOrder] (
    [ID] BIGINT NOT NULL,
    [Number] NVARCHAR(50) NOT NULL,
    [DueDate] DATETIME2 NULL,
    [Supplier.Code] NVARCHAR(50) NULL,
    [Supplier.Name] NVARCHAR(255) NULL,
    [Branch.Code] NVARCHAR(255) NULL,
    [Branch.Description] NVARCHAR(255) NULL,
    [$Items] NVARCHAR(MAX) NULL,
    [WorkflowStatus.Code] NVARCHAR(50) NULL,
    [WorkflowStatus.Description] NVARCHAR(255) NULL,
    [AlternateReference] NVARCHAR(255) NULL,
    [CALC_AGRClosed] BIT NULL,
    [UpdatedOn] DATETIME2 NULL,
    [CreatedOn] DATETIME2 NULL
);
