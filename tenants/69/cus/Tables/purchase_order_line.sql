CREATE TABLE [cus].[purchase_order_line] (
    [purchase_order_no] NVARCHAR(128) NOT NULL,
    [product_item_no] NVARCHAR(255) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [delivery_date] DATE NOT NULL,
    [quantity] DECIMAL(18,4) NOT NULL,
    [expire_date] DATE NULL,
    [deliv_status] TINYINT NOT NULL,
    [order_type] TINYINT NOT NULL,
    CONSTRAINT [PK_cus_purchase_order_line] PRIMARY KEY (delivery_date,location_no,product_item_no,purchase_order_no)
);
