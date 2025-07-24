CREATE TABLE [cus].[variant_transaction_split] (
    [vts_id] INT NOT NULL,
    [vts_vth_id] INT NULL,
    [vts_oli_id] INT NULL,
    [vts_datetime] DATETIME NOT NULL,
    [vts_quantity] DECIMAL(18,4) NULL,
    [vts_tt_id] INT NULL,
    CONSTRAINT [pk_cus_variant_transaction_split] PRIMARY KEY (vts_id)
);
