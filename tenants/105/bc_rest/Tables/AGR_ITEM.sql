CREATE TABLE [bc_rest_cus].[AGR_ITEM] (
    [No_] NVARCHAR(20) NOT NULL,
    [Manufacturer_Code] NVARCHAR(100) NOT NULL,
    [Min_Del_DutyPaid_LCY] INT NULL,
    [SKU_Item_Type_Code] NVARCHAR(100) NOT NULL,
    [SKU_Location_Code] NVARCHAR(100) NOT NULL,
    [SKU_Variant_Code] NVARCHAR(100) NOT NULL,
    [SKU_Reordering_Policy] NVARCHAR(100) NOT NULL,
    CONSTRAINT [pk_AGR_ITEM] PRIMARY KEY (No_,SKU_Location_Code,SKU_Variant_Code)
);
