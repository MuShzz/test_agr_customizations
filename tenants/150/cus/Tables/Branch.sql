CREATE TABLE [cus].[Branch] (
    [ID] BIGINT NOT NULL,
    [Code] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(255) NULL,
    [_Company.Code] NVARCHAR(255) NULL,
    [_Company.Name] NVARCHAR(255) NULL
);
