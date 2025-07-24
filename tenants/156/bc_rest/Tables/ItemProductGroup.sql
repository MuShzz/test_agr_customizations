CREATE TABLE [bc_rest_cus].[ItemProductGroup] (
    [No] NVARCHAR(20) NOT NULL,
    [ItemCategoryCode] NVARCHAR(20) NOT NULL,
    [LSCRetailProductCode] NVARCHAR(50) NOT NULL,
    CONSTRAINT [pk_bc_rest_cus_itemproductgroup] PRIMARY KEY (No)
);
