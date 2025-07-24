CREATE TABLE [cus].[product_purchase_info] (
    [product_item_no] NVARCHAR(255) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [vendor_no] NVARCHAR(255) NOT NULL,
    [primary] BIT NOT NULL,
    [lead_time_days] SMALLINT NULL,
    [order_frequency_days] SMALLINT NULL,
    [min_order_qty] DECIMAL(18,4) NULL,
    [cost_price] DECIMAL(18,4) NULL,
    [purchase_price] DECIMAL(18,4) NULL,
    [order_multiple] DECIMAL(18,4) NULL,
    [qty_pallet] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_cus_product_purchase_info] PRIMARY KEY (location_no,product_item_no,vendor_no)
);
