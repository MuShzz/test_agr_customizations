CREATE TABLE [cus].[OrdLn] (
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
    [CfDelDt] INT NOT NULL,
    [DelDt] INT NULL,
    [FrStc] INT NULL,
    [FinDt] INT NOT NULL,
    CONSTRAINT [pk_cus_OrdLn] PRIMARY KEY (LnNo,OrdNo,ProdNo,TrDt)
);
