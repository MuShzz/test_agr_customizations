CREATE TABLE [cus].[transfer_order_line] (
    [transfer_order_no] NVARCHAR(128) NOT NULL,
    [product_item_no] NVARCHAR(255) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [order_from_location_no] NVARCHAR(255) NOT NULL,
    [delivery_date] DATE NOT NULL,
    [quantity] DECIMAL(18,4) NOT NULL,
    [expire_date] DATE NULL,
    [deliv_status] TINYINT NOT NULL,
    CONSTRAINT [PK_cus_transfer_order_line] PRIMARY KEY (delivery_date,location_no,product_item_no,transfer_order_no)
);
