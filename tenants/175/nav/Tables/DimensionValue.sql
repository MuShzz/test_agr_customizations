CREATE TABLE [nav_cus].[DimensionValue] (
    [Dimension Code] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(20) NOT NULL,
    [Name] NVARCHAR(50) NOT NULL,
    [Blocked] TINYINT NOT NULL,
    [Valid in AGR] TINYINT NOT NULL,
    CONSTRAINT [pk_DimensionValue] PRIMARY KEY (Code,Dimension Code)
);
