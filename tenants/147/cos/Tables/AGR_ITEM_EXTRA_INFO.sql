CREATE TABLE [cos_cus].[AGR_ITEM_EXTRA_INFO] (
    [ITEM_NO] NVARCHAR(255) NOT NULL,
    [ALTItemNo] NVARCHAR(255) NULL,
    [ITEMNAME3] NVARCHAR(MAX) NULL,
    CONSTRAINT [pk_cos_cus_item_extra_info] PRIMARY KEY (ITEM_NO)
);
