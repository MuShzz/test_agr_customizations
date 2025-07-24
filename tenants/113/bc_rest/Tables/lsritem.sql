CREATE TABLE [bc_rest_cus].[lsritem] (
    [no] NVARCHAR(20) NOT NULL,
    [division_code] NVARCHAR(20) NOT NULL,
    [retail_product_group] NVARCHAR(20) NOT NULL,
    [item_category_code] NVARCHAR(20) NULL,
    CONSTRAINT [pk_bc_rest_cus_lsritem] PRIMARY KEY (no)
);
