CREATE VIEW [bc_rest_cus].[v_BOM_COMPONENT]
AS
SELECT ITEM_NO,
       COMPONENT_ITEM_NO,
       QUANTITY
FROM bc_rest_cus.prep_bom_component
