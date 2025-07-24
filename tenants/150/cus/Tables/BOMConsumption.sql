CREATE TABLE [cus].[BOMConsumption] (
    [ID] BIGINT NOT NULL,
    [_Owner_.Date] DATETIME NULL,
    [_Owner_.ShortTypeName] NVARCHAR(255) NULL,
    [Product.Code] NVARCHAR(255) NULL,
    [Product.Description] NVARCHAR(255) NULL,
    [StockBin.Location.Branch.Code] NVARCHAR(255) NULL,
    [Quantity] DECIMAL(18,4) NULL,
    [QuantityIn] DECIMAL(18,4) NULL,
    [QuantityOut] DECIMAL(18,4) NULL,
    [Type.Value] DECIMAL(18,4) NULL,
    [Type.Name] NVARCHAR(255) NULL
);
