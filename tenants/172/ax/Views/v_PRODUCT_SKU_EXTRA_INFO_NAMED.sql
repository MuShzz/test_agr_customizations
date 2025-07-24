CREATE VIEW ax_cus.v_PRODUCT_SKU_EXTRA_INFO_NAMED
AS
SELECT
        sku.[NO],
        sku.LOCATION_NO,
        sku.SIZE_NO,
        sku.COLOUR_NO,
        sku.STYLE_NO,

        sku.PRODUCT_GROUP_NO_LEVEL_3,
        sku.PRODUCT_GROUP_NO_LEVEL_4,

        ig3.[name]  AS PRODUCT_GROUP_NAME_LEVEL_3,
        ig4.[name]  AS PRODUCT_GROUP_NAME_LEVEL_4,


        sku.[column]          
FROM    ax_cus.v_PRODUCT_SKU_EXTRA_INFO AS sku  
LEFT JOIN ax_cus.v_ITEM_GROUP           AS ig3
       ON ig3.[no] = sku.PRODUCT_GROUP_NO_LEVEL_3
LEFT JOIN ax_cus.v_ITEM_GROUP           AS ig4
       ON ig4.[no] = sku.PRODUCT_GROUP_NO_LEVEL_4;

