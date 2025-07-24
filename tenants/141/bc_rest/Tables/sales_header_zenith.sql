CREATE TABLE [bc_rest_cus].[sales_header_zenith] (
    [DocumentType] VARCHAR(20) NOT NULL,
    [No] VARCHAR(20) NOT NULL,
    [LocationCode] VARCHAR(10) NOT NULL,
    [SelltoCustomerNo] VARCHAR(20) NOT NULL,
    [RequestedDeliveryDate] DATETIME2 NOT NULL,
    [PromisedDeliveryDate] DATETIME2 NOT NULL,
    [Status] VARCHAR(20) NULL,
    CONSTRAINT [PK_bc_rest_cus_sales_header_zenith] PRIMARY KEY (DocumentType,No)
);
