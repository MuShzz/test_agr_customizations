CREATE TABLE [bc_rest_cus].[UndeliveredCDI] (
    [ItemNo] NVARCHAR(50) NOT NULL,
    [LocationCode] NVARCHAR(50) NOT NULL,
    [OrderNo] NVARCHAR(50) NOT NULL,
    [ExpectedReceiptDate] DATE NOT NULL,
    [Quantity] DECIMAL(18,4) NULL,
    [QtyToReceive] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_bc_rest_cus_undelivered_cdi] PRIMARY KEY (ExpectedReceiptDate,ItemNo,LocationCode,OrderNo)
);
