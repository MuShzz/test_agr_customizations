CREATE TABLE [cus].[customer_sale_transaction] (
    [transaction_id] BIGINT NOT NULL,
    [product_item_no] NVARCHAR(255) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [date] DATE NOT NULL,
    [customer_no] NVARCHAR(255) NOT NULL,
    [reference_no] NVARCHAR(255) NOT NULL,
    [quantity] DECIMAL(18,4) NOT NULL,
    [is_sales_order] BIT NOT NULL,
    [is_excluded] BIT NOT NULL DEFAULT ((0)),
    CONSTRAINT [PK_cus_customer_sale_transaction] PRIMARY KEY (transaction_id)
);
