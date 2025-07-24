CREATE TABLE [cus].[ProductionBOMLine] (
    [Production BOM No_] NVARCHAR(20) NOT NULL,
    [Version Code] NVARCHAR(20) NOT NULL,
    [Line No_] INT NOT NULL,
    [Type] INT NOT NULL,
    [No_] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [Unit of Measure Code] NVARCHAR(10) NOT NULL,
    [Quantity] NUMERIC(38,20) NOT NULL,
    [Quantity per] NUMERIC(38,20) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_ProductionBOMLine] PRIMARY KEY (Company,Line No_,Production BOM No_,Version Code)
);
