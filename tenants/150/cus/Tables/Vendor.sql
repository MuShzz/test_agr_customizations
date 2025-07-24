CREATE TABLE [cus].[Vendor] (
    [ID] BIGINT NOT NULL,
    [Code] NVARCHAR(100) NOT NULL,
    [Name] NVARCHAR(255) NULL,
    [Options.LeadTimeQuantity] DECIMAL(18,4) NULL,
    [WorkflowStatus.Code] NVARCHAR(255) NULL,
    [WorkflowStatus.Description] NVARCHAR(255) NULL
);
