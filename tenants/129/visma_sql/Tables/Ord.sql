CREATE TABLE [visma_sql_cus].[Ord] (
    [OrdNo] INT NOT NULL,
    [TrTp] INT NULL,
    [OrdTp] INT NULL,
    [OrdDt] INT NOT NULL,
    [CustNo] INT NOT NULL,
    [OrdPrSt] INT NOT NULL,
    [CfDelDt] INT NOT NULL,
    [DelDt] INT NOT NULL,
    [FrStc] INT NOT NULL,
    CONSTRAINT [PK_visma_sql_cus_Ord] PRIMARY KEY (OrdNo)
);
