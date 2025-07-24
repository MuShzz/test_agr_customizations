CREATE TABLE [sap_b1_cus].[PCH1] (
    [DocEntry] INT NOT NULL,
    [LineNum] INT NOT NULL,
    [ItemCode] NVARCHAR(50) NULL,
    [Dscription] NVARCHAR(200) NULL,
    [OpenQty] NUMERIC(19,6) NULL,
    [ShipDate] DATETIME NULL,
    [WhsCode] NVARCHAR(8) NULL,
    [OpenInvQty] NUMERIC(19,6) NULL,
    [LineStatus] CHAR(1) NULL,
    CONSTRAINT [PK_sap_b1_cus_PCH1] PRIMARY KEY (DocEntry,LineNum)
);
