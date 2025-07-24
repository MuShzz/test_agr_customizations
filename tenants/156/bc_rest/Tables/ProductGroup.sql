CREATE TABLE [bc_rest_cus].[ProductGroup] (
    [Code] NVARCHAR(20) NOT NULL,
    [ItemCategoryCode] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(255) NULL,
    [CategoryName] NVARCHAR(100) NOT NULL,
    [BuyerGroupCode] NVARCHAR(50) NULL,
    CONSTRAINT [pk_bc_rest_cus_productgroup] PRIMARY KEY (Code)
);
