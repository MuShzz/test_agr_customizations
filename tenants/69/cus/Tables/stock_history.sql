CREATE TABLE [cus].[stock_history] (
    [transaction_id] BIGINT NOT NULL,
    [product_item_no] NVARCHAR(255) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [date] DATE NOT NULL,
    [stock_move] DECIMAL(18,4) NOT NULL,
    [stock_level] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_cus_stock_history] PRIMARY KEY (transaction_id)
);
