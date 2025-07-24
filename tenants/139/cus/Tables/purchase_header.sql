CREATE TABLE [cus].[purchase_header] (
    [DocumentType] VARCHAR(20) NOT NULL,
    [No] VARCHAR(20) NOT NULL,
    [BuyfromVendorNo] VARCHAR(20) NULL,
    [OrderDate] DATETIME2 NULL,
    [PostingDate] DATETIME2 NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_cus_purchase_header] PRIMARY KEY (Company,DocumentType,No)
);
