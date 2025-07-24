CREATE TABLE [cus].[variant_stock_location] (
    [vsl_id] INT NOT NULL,
    [vsl_vad_id] INT NULL,
    [vsl_sl_id] INT NOT NULL,
    [vsl_free_stock_quantity] DECIMAL(18,4) NULL,
    [vsl_overall_stock_quantity] DECIMAL(18,4) NULL,
    CONSTRAINT [pk_cus_variant_stock_location] PRIMARY KEY (vsl_id)
);
