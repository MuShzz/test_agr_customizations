CREATE TABLE [cus].[sales_header] (
    [DocumentType] VARCHAR(20) NOT NULL,
    [No] VARCHAR(20) NOT NULL,
    [LocationCode] VARCHAR(10) NOT NULL,
    [SelltoCustomerNo] VARCHAR(20) NOT NULL,
    [RequestedDeliveryDate] DATETIME2 NOT NULL,
    [PromisedDeliveryDate] DATETIME2 NOT NULL,
    [Status] VARCHAR(20) NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_cus_sales_header] PRIMARY KEY (Company,DocumentType,No)
);
