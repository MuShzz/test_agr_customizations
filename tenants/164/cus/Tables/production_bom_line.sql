CREATE TABLE [cus].[production_bom_line] (
    [ProductionBOMNo] NVARCHAR(20) NOT NULL,
    [VersionCode] NVARCHAR(20) NOT NULL,
    [LineNo] INT NOT NULL,
    [Type] NVARCHAR(50) NOT NULL,
    [No] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [UnitofMeasureCode] NVARCHAR(10) NOT NULL,
    [Quantity] NUMERIC(38,20) NOT NULL,
    [Quantityper] NUMERIC(38,20) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_production_bom_line] PRIMARY KEY (Company,LineNo,ProductionBOMNo,VersionCode)
);
