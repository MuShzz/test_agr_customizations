CREATE TABLE [sap_b1_cus].[WOR1] (
    [DocEntry] INT NOT NULL,
    [LineNum] INT NOT NULL,
    [StartDate] DATETIME NULL,
    [IssuedQty] NUMERIC(19,6) NULL,
    [PlannedQty] NUMERIC(19,6) NULL,
    [wareHouse] NVARCHAR(8) NULL,
    [ItemCode] NVARCHAR(50) NULL,
    CONSTRAINT [PK_sap_b1_cus_WOR1] PRIMARY KEY (DocEntry,LineNum)
);
