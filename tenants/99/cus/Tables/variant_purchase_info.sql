CREATE TABLE [cus].[variant_purchase_info] (
    [vapi_id] INT NOT NULL,
    [vapi_vad_id] INT NULL,
    [vapi_estimated_cost] DECIMAL(18,4) NOT NULL,
    [vapi_cost_per] DECIMAL(18,4) NULL,
    CONSTRAINT [pk_cus_variant_purchase_info] PRIMARY KEY (vapi_id)
);
