CREATE TABLE [cus].[StockBin] (
    [ID] BIGINT NOT NULL,
    [Code] NVARCHAR(50) NULL,
    [Description] NVARCHAR(200) NULL,
    [Location.Code] NVARCHAR(200) NULL,
    [Status.Name] NVARCHAR(255) NULL
);
