
CREATE VIEW [bc_sql_cus].[v_CustomColumns_AttributeValue_ownBrand]
as
SELECT
        [Link Field 1],
        [Attribute Code],
      CASE WHEN [Attribute Value] = 'Y' THEN
        1
       ELSE 0 end AS [Attribute Value]
    
  FROM [bc_sql_cus].CustomColumns_AttributeValue 


