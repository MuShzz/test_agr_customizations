CREATE TABLE [cus].[supplier_detail] (
    [sd_id] INT NOT NULL,
    [sd_name] NVARCHAR(100) NOT NULL,
    [sd_ow_account] NVARCHAR(30) NOT NULL,
    [sd_sde_id] INT NULL,
    CONSTRAINT [pk_cus_supplier_detail] PRIMARY KEY (sd_id)
);
