CREATE VIEW [cus].v_BOM_COMPONENT
AS
SELECT CAST(product_item_no AS nvarchar(255))           AS [ITEM_NO],
       CAST(component_product_item_no AS nvarchar(255)) AS [COMPONENT_ITEM_NO],
       CAST(quantity AS decimal(18, 4))                 AS [QUANTITY]
FROM cus.[bom_component]
