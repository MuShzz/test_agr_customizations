CREATE TABLE [cus].[unit_of_measure] (
    [Code] NVARCHAR(10) NOT NULL,
    [Description] NVARCHAR(50) NOT NULL,
    [InternationalStandardCode] NVARCHAR(10) NOT NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_UnitofMeasure] PRIMARY KEY (Code,Company)
);
