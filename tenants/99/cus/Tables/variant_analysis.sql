CREATE TABLE [cus].[variant_analysis] (
    [vaa_id] INT NOT NULL,
    [vaa_vad_id] INT NOT NULL,
    [vaa_n_6] DECIMAL(18,4) NULL,
    [vaa_n_5] DECIMAL(18,4) NULL,
    CONSTRAINT [pk_cus_variant_analysis] PRIMARY KEY (vaa_id)
);
