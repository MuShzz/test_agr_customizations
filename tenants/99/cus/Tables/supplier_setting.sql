CREATE TABLE [cus].[supplier_setting] (
    [sset_id] INT NOT NULL,
    [sset_supplier_id] INT NOT NULL,
    [sset_do_not_use] BIT NOT NULL,
    [sset_default_vat_id] INT NULL,
    CONSTRAINT [pk_cus_supplier_setting] PRIMARY KEY (sset_id)
);
