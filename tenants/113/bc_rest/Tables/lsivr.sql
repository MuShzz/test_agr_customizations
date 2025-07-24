CREATE TABLE [bc_rest_cus].[lsivr] (
    [item_no] NVARCHAR(20) NOT NULL,
    [variant_code] NVARCHAR(20) NOT NULL,
    [framework_code] NVARCHAR(20) NOT NULL,
    [variant_dimension_1] NVARCHAR(20) NULL,
    [variant_dimension_2] NVARCHAR(20) NULL,
    CONSTRAINT [pk_bc_rest_cus_lsivr] PRIMARY KEY (item_no,variant_code)
);
