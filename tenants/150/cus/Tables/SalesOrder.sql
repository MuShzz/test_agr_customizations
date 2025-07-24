CREATE TABLE [cus].[SalesOrder] (
    [ID] BIGINT NOT NULL,
    [Number] NVARCHAR(50) NOT NULL,
    [Branch.Code] NVARCHAR(255) NULL,
    [Branch.Description] NVARCHAR(255) NULL,
    [$Items] NVARCHAR(MAX) NULL,
    [DueDate] NVARCHAR(255) NULL,
    [Customer.Code] NVARCHAR(255) NULL,
    [Customer.Name] NVARCHAR(255) NULL,
    [WorkflowStatus.Code] NVARCHAR(255) NULL,
    [WorkflowStatus.Description] NVARCHAR(255) NULL,
    [UpdatedOn] DATETIME2 NULL,
    [CreatedOn] DATETIME2 NULL
);
