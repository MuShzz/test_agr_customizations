CREATE TABLE [cus].[sales_shipment_header] (
    [No] NVARCHAR(20) NOT NULL,
    [OrderNo] NVARCHAR(20) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_sales_shipment_header] PRIMARY KEY (Company,No)
);
