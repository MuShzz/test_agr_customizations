CREATE TABLE [cus].[item_ledger_entry] (
    [EntryNo] INT NOT NULL,
    [ItemNo] VARCHAR(20) NOT NULL,
    [PostingDate] DATETIME2 NOT NULL,
    [EntryType] VARCHAR(50) NOT NULL,
    [LocationCode] VARCHAR(10) NOT NULL,
    [Quantity] DECIMAL(38,20) NOT NULL,
    [RemainingQuantity] DECIMAL(38,20) NOT NULL,
    [InvoicedQuantity] DECIMAL(38,20) NOT NULL,
    [QtyperUnitofMeasure] DECIMAL(38,20) NOT NULL,
    [UnitofMeasureCode] VARCHAR(10) NOT NULL,
    [VariantCode] VARCHAR(10) NULL,
    [SourceNo] VARCHAR(20) NOT NULL,
    [DocumentNo] VARCHAR(20) NOT NULL,
    [ExpirationDate] DATETIME2 NULL,
    [LotNo] VARCHAR(50) NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [pk_cus_item_ledger_entry] PRIMARY KEY (Company,EntryNo)
);
