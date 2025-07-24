CREATE TABLE [cus].[sales_order_line] (
    [sales_order_no] NVARCHAR(128) NOT NULL,
    [product_item_no] NVARCHAR(255) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [quantity] DECIMAL(18,4) NOT NULL,
    [expire_date] DATE NULL,
    [delivery_date] DATE NULL,
    [delivery_status] TINYINT NOT NULL,
    CONSTRAINT [PK_cus_sales_order_line] PRIMARY KEY (location_no,product_item_no,quantity,sales_order_no)
);
