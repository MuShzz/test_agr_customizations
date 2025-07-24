CREATE TABLE [cus].[ProdTr_BU] (
    [JNo] INT NOT NULL,
    [TrNo] INT NOT NULL,
    [TrDt] INT NOT NULL,
    [ProdNo] NVARCHAR(250) NOT NULL,
    [FrStc] INT NOT NULL,
    [PrTp] INT NOT NULL,
    [StcMov] DECIMAL(18,4) NULL,
    [CustNo] INT NOT NULL,
    [TrTp] INT NULL,
    [InvoCust] NVARCHAR(250) NULL,
    [OrdNo] INT NULL,
    [FinDt] INT NULL
);
