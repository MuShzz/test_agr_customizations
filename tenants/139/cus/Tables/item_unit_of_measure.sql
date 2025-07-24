CREATE TABLE [cus].[item_unit_of_measure] (
    [Code] VARCHAR(10) NOT NULL,
    [ItemNo] VARCHAR(20) NOT NULL,
    [Cubage] DECIMAL(18,6) NULL,
    [Height] DECIMAL(18,4) NULL,
    [Length] DECIMAL(18,4) NULL,
    [QtyperUnitofMeasure] DECIMAL(18,4) NULL,
    [Weight] DECIMAL(18,6) NULL,
    [Width] DECIMAL(18,0) NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_cus_item_units_of_measure] PRIMARY KEY (Code,Company,ItemNo)
);
