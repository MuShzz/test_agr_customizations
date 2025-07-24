CREATE TABLE [cus].[variant_stock_quantity] (
    [vasq_id] INT NOT NULL,
    [vasq_vad_id] INT NULL,
    [vasq_free_stock_quantity] DECIMAL(18,4) NULL,
    CONSTRAINT [pk_cus_variant_stock_quantity] PRIMARY KEY (vasq_id)
);
