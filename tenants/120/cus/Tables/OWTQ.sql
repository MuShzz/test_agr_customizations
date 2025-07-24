CREATE TABLE [cus].[OWTQ] (
    [DocEntry] INT NOT NULL,
    [DocNum] INT NOT NULL,
    [DocType] CHAR(1) NULL,
    [CANCELED] CHAR(1) NULL,
    [DocStatus] CHAR(1) NULL,
    [InvntSttus] CHAR(1) NULL,
    [Transfered] CHAR(1) NULL,
    [DocDate] DATETIME NULL,
    [DocDueDate] DATETIME NULL,
    [CardCode] NVARCHAR(15) NULL,
    [CardName] NVARCHAR(100) NULL,
    CONSTRAINT [PK_erp_cus_OWTQ] PRIMARY KEY (DocEntry)
);
