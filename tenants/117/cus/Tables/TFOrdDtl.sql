CREATE TABLE [cus].[TFOrdDtl] (
    [TFOrdNum] NVARCHAR(50) NULL,
    [TFOrdLine] INT NULL,
    [OpenLine] BIT NULL,
    [Shipped] BIT NULL,
    [PartNum] NVARCHAR(50) NULL,
    [OurStockQty] FLOAT(53) NULL,
    [OurStockShippedQty] FLOAT(53) NULL,
    [Plant] NVARCHAR(50) NULL,
    [ToPlant] NVARCHAR(50) NULL,
    [RequestDate] DATETIME NULL,
    [NeedByDate] DATETIME NULL,
    [ReceivedQty] FLOAT(53) NULL,
    [OurStockQtyUOM] NVARCHAR(10) NULL
);
