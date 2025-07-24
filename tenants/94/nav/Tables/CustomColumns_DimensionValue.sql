CREATE TABLE [nav_cus].[CustomColumns_DimensionValue] (
    [Dimension Code] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(20) NOT NULL,
    [Name] NVARCHAR(50) NOT NULL,
    CONSTRAINT [PK_CustomColumns_DimensionValue] PRIMARY KEY (Code,Dimension Code)
);
