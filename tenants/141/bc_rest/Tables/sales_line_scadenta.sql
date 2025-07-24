CREATE TABLE [bc_rest_cus].[sales_line_scadenta] (
    [DocumentType] VARCHAR(50) NOT NULL,
    [DocumentNo] VARCHAR(50) NOT NULL,
    [LineNo] INT NOT NULL,
    [Quantity] DECIMAL(18,4) NOT NULL,
    [VariantCode] VARCHAR(10) NOT NULL,
    [ItemReferenceNo] VARCHAR(200) NOT NULL,
    [LocationCode] VARCHAR(20) NOT NULL,
    [No] VARCHAR(20) NOT NULL,
    [OutstandingQtyBase] DECIMAL(18,4) NOT NULL,
    [PurchaseOrderNo] VARCHAR(20) NOT NULL,
    [PurchOrderLineNo] INT NOT NULL,
    [ShipmentDate] DATETIME2 NOT NULL,
    [DropShipment] BIT NOT NULL,
    CONSTRAINT [PK_bc_rest_cus_sales_line_scadenta] PRIMARY KEY (DocumentNo,DocumentType,LineNo)
);
