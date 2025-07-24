CREATE TABLE [visma_sql_cus].[ProdTr] (
    [JNo] INT NOT NULL,
    [TrNo] INT NOT NULL,
    [TrDt] INT NOT NULL,
    [ProdNo] NVARCHAR(250) NOT NULL,
    [FrStc] INT NOT NULL,
    [PrTp] INT NOT NULL,
    [StcMov] DECIMAL(18,4) NOT NULL,
    [CustNo] INT NOT NULL,
    [TrTp] INT NOT NULL,
    [InvoCust] NVARCHAR(250) NOT NULL,
    [OrdNo] INT NOT NULL,
    [FinDt] INT NOT NULL,
    [TransSt] INT NOT NULL,
    [NoInvoAb] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_visma_sql_cus_ProdTr] PRIMARY KEY (JNo,TrNo)
);
