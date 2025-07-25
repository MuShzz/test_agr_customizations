CREATE TABLE [cos_cus].[AGR_SALES_ORDERS_LINE] (
    [SALES_ORDER_NO] NVARCHAR(128) NOT NULL,
    [PRODUCT_ITEM_NO] NVARCHAR(255) NOT NULL,
    [LOCATION_NO] NVARCHAR(255) NOT NULL,
    [QUANTITY] DECIMAL(18,4) NULL,
    [EXPIRE_DATE] DATE NULL,
    [DELIVERY_DATE] DATE NOT NULL,
    [DELIVERY_STATUS] TINYINT NULL,
    CONSTRAINT [pk_cos_agr_sales_orders_line] PRIMARY KEY (DELIVERY_DATE,LOCATION_NO,PRODUCT_ITEM_NO,SALES_ORDER_NO)
);
