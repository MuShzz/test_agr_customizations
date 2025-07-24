CREATE TABLE [sap_b1_cus].[OPCH] (
    [DocNum] INT NOT NULL,
    [DocEntry] INT NOT NULL,
    [CANCELED] CHAR(1) NULL,
    [isIns] CHAR(1) NULL,
    [InvntSttus] CHAR(1) NULL,
    [DocDueDate] DATETIME NULL,
    CONSTRAINT [PK_sap_b1_cus_OPCH] PRIMARY KEY (DocEntry)
);
