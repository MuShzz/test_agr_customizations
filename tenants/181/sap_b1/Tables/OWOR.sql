CREATE TABLE [sap_b1_cus].[OWOR] (
    [DocEntry] INT NOT NULL,
    [DocNum] INT NOT NULL,
    [ItemCode] NVARCHAR(50) NULL,
    [Warehouse] NVARCHAR(8) NULL,
    [DueDate] DATETIME NULL,
    [PlannedQty] NUMERIC(19,6) NULL,
    [CmpltQty] NUMERIC(19,6) NULL,
    [Status] CHAR(1) NULL,
    CONSTRAINT [PK_sap_b1_cus_OWOR] PRIMARY KEY (DocEntry)
);
