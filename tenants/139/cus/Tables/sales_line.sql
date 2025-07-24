CREATE TABLE [cus].[sales_line] (
    [DocumentType] VARCHAR(50) NOT NULL,
    [DocumentNo] VARCHAR(50) NOT NULL,
    [LineNo] INT NOT NULL,
    [Quantity] DECIMAL(18,4) NOT NULL,
    [VariantCode] VARCHAR(10) NOT NULL,
    [ItemReferenceNo] VARCHAR(200) NULL,
    [LocationCode] VARCHAR(20) NOT NULL,
    [No] VARCHAR(20) NOT NULL,
    [OutstandingQtyBase] DECIMAL(18,4) NOT NULL,
    [PurchaseOrderNo] VARCHAR(20) NOT NULL,
    [PurchOrderLineNo] INT NOT NULL,
    [ShipmentDate] DATETIME2 NOT NULL,
    [DropShipment] BIT NOT NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_cus_sales_line] PRIMARY KEY (Company,DocumentNo,DocumentType,LineNo)
);
