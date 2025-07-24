CREATE TABLE [cus].[ProductionBOMHeader] (
    [No_] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [Description 2] NVARCHAR(50) NOT NULL,
    [Search Name] NVARCHAR(100) NOT NULL,
    [Unit of Measure Code] NVARCHAR(10) NOT NULL,
    [Low-Level Code] INT NOT NULL,
    [Creation Date] DATETIME2 NOT NULL,
    [Last Date Modified] DATETIME2 NOT NULL,
    [Status] INT NOT NULL,
    [Version Nos_] NVARCHAR(10) NOT NULL,
    [No_ Series] NVARCHAR(10) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_ProductionBOMHeader] PRIMARY KEY (Company,No_)
);
