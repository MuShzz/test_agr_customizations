CREATE TABLE [cus].[transfer_line] (
    [DocumentNo] VARCHAR(20) NOT NULL,
    [LineNo] INT NOT NULL,
    [ItemNo] VARCHAR(20) NOT NULL,
    [Quantity] DECIMAL(38,20) NOT NULL,
    [UnitofMeasureCode] VARCHAR(10) NOT NULL,
    [QuantityReceived] DECIMAL(38,20) NOT NULL,
    [Status] VARCHAR(20) NOT NULL,
    [QuantityBase] DECIMAL(38,20) NOT NULL,
    [OutstandingQtyBase] DECIMAL(38,20) NOT NULL,
    [QtyReceivedBase] DECIMAL(38,20) NOT NULL,
    [QtyperUnitofMeasure] DECIMAL(38,20) NOT NULL,
    [UnitofMeasure] VARCHAR(10) NOT NULL,
    [OutstandingQuantity] DECIMAL(38,20) NOT NULL,
    [TransferfromCode] VARCHAR(10) NOT NULL,
    [TransfertoCode] VARCHAR(10) NOT NULL,
    [ShipmentDate] DATETIME2 NOT NULL,
    [ReceiptDate] DATETIME2 NOT NULL,
    [VariantCode] VARCHAR(10) NOT NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [pk_cus_transfer_line] PRIMARY KEY (Company,DocumentNo,LineNo)
);
