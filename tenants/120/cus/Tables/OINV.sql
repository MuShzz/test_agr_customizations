CREATE TABLE [cus].[OINV] (
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
    [Address] NVARCHAR(254) NULL,
    [ToWhsCode] NVARCHAR(8) NULL,
    [Handwrtten] CHAR(1) NULL,
    [U_CXS_TRID] NVARCHAR(50) NULL,
    [U_TRC_Ecom_WebId] NVARCHAR(50) NULL,
    CONSTRAINT [PK_erp_cus_OINV] PRIMARY KEY (DocEntry)
);
