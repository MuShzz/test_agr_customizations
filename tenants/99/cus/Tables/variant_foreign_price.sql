CREATE TABLE [cus].[variant_foreign_price] (
    [vafp_id] INT NOT NULL,
    [vafp_vad_id] INT NULL,
    [vafp_rsp_exc_vat] DECIMAL(18,4) NOT NULL,
    [vafp_price_per] DECIMAL(18,4) NULL,
    [vafp_input_datetime] DATETIME NULL,
    [vafp_last_amended_datetime] DATETIME NULL,
    [vafp_c_id] INT NULL,
    [vafp_base_price] BIT NULL,
    CONSTRAINT [pk_cus_variant_foreign_price] PRIMARY KEY (vafp_id)
);
