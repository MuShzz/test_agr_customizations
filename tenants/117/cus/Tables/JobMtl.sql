CREATE TABLE [cus].[JobMtl] (
    [JobNum] NVARCHAR(14) NOT NULL,
    [MtlSeq] INT NOT NULL,
    [AssemblySeq] INT NOT NULL,
    [PartNum] NVARCHAR(50) NULL,
    [Plant] NVARCHAR(50) NULL,
    [ReqDate] DATE NULL,
    [RequiredQty] DECIMAL(22,8) NULL,
    [IssuedQty] DECIMAL(22,8) NULL,
    [QtyPer] DECIMAL(22,8) NULL,
    [IUM] NVARCHAR(6) NULL,
    [JobComplete] BIT NULL,
    [IssuedComplete] BIT NULL,
    CONSTRAINT [pk_cus_jobmtl] PRIMARY KEY (AssemblySeq,JobNum,MtlSeq)
);
