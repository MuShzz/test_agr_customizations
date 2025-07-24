CREATE TABLE [cus].[item_unit_of_measure] (
    [Code] VARCHAR(10) NOT NULL,
    [ItemNo] VARCHAR(20) NOT NULL,
    [Cubage] DECIMAL(38,10) NULL,
    [Height] DECIMAL(38,10) NULL,
    [Length] DECIMAL(38,10) NULL,
    [QtyperUnitofMeasure] DECIMAL(38,10) NULL,
    [Weight] DECIMAL(38,10) NULL,
    [Width] DECIMAL(38,10) NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_item_units_of_measure] PRIMARY KEY (Code,Company,ItemNo)
);
