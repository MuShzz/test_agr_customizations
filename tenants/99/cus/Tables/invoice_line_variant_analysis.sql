CREATE TABLE [cus].[invoice_line_variant_analysis] (
    [iliva_id] INT NOT NULL,
    [iliva_ili_id] INT NOT NULL,
    [iliva_n_6] DECIMAL(18,4) NULL,
    CONSTRAINT [pk_cus_invoice_line_variant_analysis] PRIMARY KEY (iliva_id)
);
