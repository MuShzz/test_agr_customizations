CREATE TABLE [cus].[OrdLn_BU] (
    [OrdNo] INT NOT NULL,
    [LnNo] INT NOT NULL,
    [TrDt] INT NOT NULL,
    [CustNo] INT NULL,
    [InvoCust] INT NULL,
    [SupNo] INT NULL,
    [ProdNo] NVARCHAR(255) NOT NULL,
    [ArDt] INT NOT NULL,
    [NoInvoAb] INT NOT NULL,
    [DelAltNo] INT NULL,
    [CfDelDt] INT NULL,
    [DelDt] INT NULL,
    [FrStc] INT NULL
);
