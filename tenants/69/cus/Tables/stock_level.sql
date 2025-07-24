CREATE TABLE [cus].[stock_level] (
    [product_item_no] NVARCHAR(255) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [expire_date] DATE NOT NULL,
    [stock_units] DECIMAL(18,4) NOT NULL,
    CONSTRAINT [PK_cus_stock_level] PRIMARY KEY (expire_date,location_no,product_item_no)
);
