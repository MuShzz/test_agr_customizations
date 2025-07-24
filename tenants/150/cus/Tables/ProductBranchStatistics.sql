CREATE TABLE [cus].[ProductBranchStatistics] (
    [ID] BIGINT NOT NULL,
    [Product.Code] NVARCHAR(255) NULL,
    [Product.Description] NVARCHAR(255) NULL,
    [Product.Category.Code] NVARCHAR(255) NULL,
    [Product.Category.Description] NVARCHAR(255) NULL,
    [StockLevel] DECIMAL(18,4) NULL
);
