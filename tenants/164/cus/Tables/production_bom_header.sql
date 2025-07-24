CREATE TABLE [cus].[production_bom_header] (
    [No] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [Description2] NVARCHAR(50) NOT NULL,
    [SearchName] NVARCHAR(100) NOT NULL,
    [UnitofMeasureCode] NVARCHAR(10) NOT NULL,
    [LowLevelCode] INT NOT NULL,
    [CreationDate] DATETIME2 NOT NULL,
    [LastDateModified] DATETIME2 NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [VersionNos] NVARCHAR(10) NOT NULL,
    [NoSeries] NVARCHAR(10) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_production_bom_header] PRIMARY KEY (Company,No)
);
