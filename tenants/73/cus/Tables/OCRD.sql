CREATE TABLE [cus].[OCRD] (
    [CardCode] NVARCHAR(15) NOT NULL,
    [CardName] NVARCHAR(100) NULL,
    [CardType] CHAR(1) NULL,
    [GroupCode] SMALLINT NULL,
    [CmpPrivate] CHAR(1) NULL,
    [Address] NVARCHAR(100) NULL,
    [ZipCode] NVARCHAR(20) NULL,
    [frozenFor] CHAR(1) NULL,
    [frozenFrom] DATETIME NULL,
    [frozenTo] DATETIME NULL,
    [SlpCode] INT NULL,
    [Currency] NVARCHAR(10) NULL,
    CONSTRAINT [PK_erp_cus_OCRD] PRIMARY KEY (CardCode)
);
