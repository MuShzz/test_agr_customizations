CREATE TABLE [ax_cus].[UNITOFMEASURE] (
    [RECID] BIGINT NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [SYMBOL] NVARCHAR(10) NOT NULL,
    [UNITOFMEASURECLASS] INT NOT NULL,
    [SYSTEMOFUNITS] INT NOT NULL,
    CONSTRAINT [PK_ax_cus_UNITOFMEASURE] PRIMARY KEY (RECID)
);
