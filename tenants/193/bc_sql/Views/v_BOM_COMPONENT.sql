CREATE VIEW [bc_sql_cus].[v_BOM_COMPONENT] AS
     SELECT ITEM_NO,
           COMPONENT_ITEM_NO,
           QUANTITY
    FROM bc_sql_cus.prep_bom_component

