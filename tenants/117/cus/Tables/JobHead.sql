CREATE TABLE [cus].[JobHead] (
    [JobNum] NVARCHAR(14) NOT NULL,
    [PartNum] NVARCHAR(50) NULL,
    [Plant] NVARCHAR(50) NULL,
    [DueDate] DATE NULL,
    [ProdQty] DECIMAL(22,8) NULL,
    [QtyCompleted] DECIMAL(22,8) NULL,
    [OrigProdQty] DECIMAL(22,8) NULL,
    [JobFirm] BIT NULL,
    [JobComplete] BIT NULL,
    [JobClosed] BIT NULL,
    [SchedStatus] NVARCHAR(3) NULL,
    [JobCompletionDate] DATE NULL,
    [ClosedDate] DATE NULL,
    CONSTRAINT [pk_cus_jobhead] PRIMARY KEY (JobNum)
);
