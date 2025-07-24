CREATE TABLE [cus].[variant_supplier_detail] (
    [vasd_id] INT NOT NULL,
    [vasd_sd_id] INT NULL,
    [vasd_vad_id] INT NULL,
    [vasd_guide_lead_time] INT NULL,
    [vasd_standard_cost] DECIMAL(18,4) NULL,
    [vasd_multiplier_qty] DECIMAL(18,4) NULL,
    [vasd_is_main_supplier] BIT NULL,
    [vasd_supplier_part_number] NVARCHAR(50) NULL,
    CONSTRAINT [pk_cus_variant_supplier_detail] PRIMARY KEY (vasd_id)
);
