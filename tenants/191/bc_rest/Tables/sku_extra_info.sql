CREATE TABLE [bc_rest_cus].[sku_extra_info] (
    [ItemNo] NVARCHAR(20) NOT NULL,
    [LocationCode] NVARCHAR(10) NOT NULL,
    [VariantCode] NVARCHAR(10) NOT NULL,
    [ReorderingPolicy] NVARCHAR(100) NOT NULL,
    CONSTRAINT [pk_bc_rest_cus_sku_extra_info] PRIMARY KEY (ItemNo,LocationCode,VariantCode)
);
