CREATE TABLE [cus].[variant_transaction_header] (
    [vth_id] INT NOT NULL,
    [vth_vad_id] INT NULL,
    [vth_sl_id] INT NOT NULL,
    [vth_tt_id] INT NULL,
    [vth_transaction_datetime] DATETIME NOT NULL,
    [vth_quantity] DECIMAL(18,4) NULL,
    [vth_current_quantity] DECIMAL(18,4) NULL,
    CONSTRAINT [pk_cus_variant_transaction_header] PRIMARY KEY (vth_id)
);
