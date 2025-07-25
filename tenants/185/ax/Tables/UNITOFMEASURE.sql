CREATE TABLE [ax_cus].[UNITOFMEASURE] (
    [SYMBOL] NVARCHAR(10) NOT NULL,
    [UNITOFMEASURECLASS] INT NOT NULL,
    [SYSTEMOFUNITS] INT NOT NULL,
    [DECIMALPRECISION] INT NOT NULL,
    [MODIFIEDDATETIME] DATETIME NOT NULL,
    [RECVERSION] INT NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    [AWSWEIGHTUNIT] INT NOT NULL,
    CONSTRAINT [PK_ax_cus_UNITOFMEASURE] PRIMARY KEY (RECID)
);
