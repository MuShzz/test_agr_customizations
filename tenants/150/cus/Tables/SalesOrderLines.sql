CREATE TABLE [cus].[SalesOrderLines] (
    [ID] BIGINT NOT NULL,
    [_Owner_.Number] NVARCHAR(255) NULL,
    [_Owner_.Branch.Code] NVARCHAR(255) NULL,
    [_Owner_.Branch.Description] NVARCHAR(255) NULL,
    [_Owner_.DueDate] NVARCHAR(255) NULL,
    [_Owner_.Customer.Code] NVARCHAR(255) NULL,
    [_Owner_.Customer.Name] NVARCHAR(255) NULL,
    [_Owner_.WorkflowStatus.Code] NVARCHAR(255) NULL,
    [_Owner_.WorkflowStatus.Description] NVARCHAR(255) NULL,
    [Product.Code] NVARCHAR(255) NULL,
    [Product.Description] NVARCHAR(255) NULL,
    [QuantityOutstanding] DECIMAL(18,4) NULL,
    [CALC_AGRClosed] BIT NULL,
    [DueDate] NVARCHAR(255) NULL,
    [UpdatedOn] DATETIME NULL
);
