CREATE TABLE [cus].[Ord] (
    [OrdNo] INT NOT NULL,
    [TrTp] INT NULL,
    [OrdTp] INT NULL,
    [OrdDt] INT NOT NULL,
    [CustNo] INT NULL,
    CONSTRAINT [PK_cus_Ord] PRIMARY KEY (OrdNo)
);
