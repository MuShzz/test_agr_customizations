CREATE TABLE [cus].[product_variant_size] (
    [no] NVARCHAR(255) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(1000) NULL,
    CONSTRAINT [PK_cus_product_variant_size] PRIMARY KEY (no)
);
