CREATE TABLE [cus].[variant_detail] (
    [vad_id] INT NOT NULL,
    [vad_variant_code] NVARCHAR(50) NULL,
    [vad_description] NVARCHAR(250) NULL,
    [vad_purchase_variant] BIT NULL,
    [vad_weight] DECIMAL(18,4) NULL,
    [vad_volume] DECIMAL(18,4) NULL,
    [vad_uom] NVARCHAR(10) NULL,
    [vad_pd_id] INT NULL,
    [vad_case_quantity] DECIMAL(18,4) NULL,
    CONSTRAINT [pk_cus_variant_detail] PRIMARY KEY (vad_id)
);
