CREATE TABLE [cus].[JobPart] (
    [JobNum] NVARCHAR(14) NULL,
    [PartNum] NVARCHAR(50) NULL,
    [RevisionNum] NVARCHAR(14) NULL,
    [Plant] NVARCHAR(50) NULL,
    [PartQty] DECIMAL(22,8) NULL,
    [StockQty] DECIMAL(22,8) NULL,
    [ShippedQty] DECIMAL(22,8) NULL,
    [QtyCompleted] DECIMAL(22,8) NULL,
    [JobComplete] BIT NULL,
    [JobClosed] BIT NULL
);
