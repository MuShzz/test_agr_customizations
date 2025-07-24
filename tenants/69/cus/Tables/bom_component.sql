CREATE TABLE [cus].[bom_component] (
    [product_item_no] NVARCHAR(255) NOT NULL,
    [component_product_item_no] NVARCHAR(255) NOT NULL,
    [quantity] DECIMAL(18,4) NOT NULL,
    CONSTRAINT [PK_cus_BOM_COMPONENT] PRIMARY KEY (component_product_item_no,product_item_no)
);
