CREATE TABLE [cus].[OITW] (
    [ItemCode] NCHAR(50) NULL,
    [WhsCode] NCHAR(8) NULL,
    [OnHand] DECIMAL(19,6) NULL,
    [IsCommited] DECIMAL(19,6) NULL,
    [OnOrder] DECIMAL(19,6) NULL,
    [Consig] DECIMAL(19,6) NULL,
    [Counted] DECIMAL(19,6) NULL,
    [WasCounted] CHAR(1) NULL,
    [UserSign] NUMERIC(6,0) NULL,
    [MinStock] DECIMAL(19,6) NULL,
    [MaxStock] DECIMAL(19,6) NULL,
    [MinOrder] DECIMAL(19,6) NULL,
    [AvgPrice] DECIMAL(19,6) NULL,
    [Locked] CHAR(1) NULL
);
