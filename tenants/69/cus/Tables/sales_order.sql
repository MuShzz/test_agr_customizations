CREATE TABLE [cus].[sales_order] (
    [no] NVARCHAR(128) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [customer_no] NVARCHAR(255) NULL,
    [delivery_date] DATE NULL,
    [delivery_status] TINYINT NOT NULL,
    CONSTRAINT [PK_cus_sales_order] PRIMARY KEY (no)
);
