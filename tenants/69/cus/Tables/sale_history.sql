CREATE TABLE [cus].[sale_history] (
    [transaction_id] BIGINT NOT NULL,
    [product_item_no] NVARCHAR(255) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [date] DATE NOT NULL,
    [sale] DECIMAL(18,4) NOT NULL,
    [transfer] DECIMAL(18,4) NULL,
    [markdown_sale] DECIMAL(18,4) NULL,
    [sale_transaction_count] INT NULL,
    [transfer_transaction_count] INT NULL,
    CONSTRAINT [PK_cus_sale_history] PRIMARY KEY (transaction_id)
);
