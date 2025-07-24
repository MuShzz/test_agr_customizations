

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Get erp endpoints
--
-- 2023.07.04.TO   Created
-- ===============================================================================

CREATE PROCEDURE [cus].[get_endpoints](
@vendor_id NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

  SELECT 
      e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'{
    "q": "'+e.[suiteql_query]+'"
}  ' AS [suiteql_query],
       'IF OBJECT_ID('''+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]) +''', ''U'') IS NOT NULL
        BEGIN
            TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]) +';
        END
        ' AS pre_copy_script,


      (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
            ,','),
            ']}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map
  FROM [cus].[endpoints] e
  WHERE task_type = 0 AND is_active = 1 AND @vendor_id IS NULL
  UNION ALL
  -- Transaction
  SELECT 
      e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'{
    "q": "'+REPLACE(e.[suiteql_query],'##UNIQUEKEY##',CAST(ISNULL((SELECT MAX([uniquekey]) FROM [cus].[Transaction]),0) AS NVARCHAR(MAX))) +'"
}  ' AS [suiteql_query],
       '' AS pre_copy_script,


      (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
            ,','),
            ']}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map
  FROM [cus].[endpoints] e
  WHERE task_type = 7 AND is_active = 1 AND @vendor_id IS NULL AND e.[step_name] = 'Transaction'
 UNION ALL
  

  -- TransactionSales
  SELECT 
      e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'{
    "q": "'+REPLACE(e.[suiteql_query],'##UNIQUEKEY##',CAST(ISNULL((SELECT MAX([uniquekey]) FROM [cus].[TransactionSales]),0) AS NVARCHAR(MAX))) +'"
}  ' AS [suiteql_query],
       '' AS pre_copy_script,


      (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
            ,','),
            ']}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map
  FROM [cus].[endpoints] e
  WHERE task_type = 7 AND is_active = 1 AND @vendor_id IS NULL AND e.[step_name] = 'TransactionSales'  

 UNION ALL



---- PER VENDOR--------------------
  -- Transaction
  SELECT 
      e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'{
    "q": "'+REPLACE(REPLACE(e.[suiteql_query],'##UNIQUEKEY##',CAST(ISNULL((SELECT MAX([uniquekey]) FROM [cus].[Transaction] WHERE vendor = t.string_value),0) AS NVARCHAR(MAX))),'##VENDORID##',CAST(t.string_value AS NVARCHAR(MAX))) +'"
}  ' AS [suiteql_query],
       '' AS pre_copy_script,


      (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
            ,','),
            ']}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map
  FROM [cus].[endpoints] e
  INNER JOIN [cus].[string_list_to_table](@vendor_id,',',0) t ON 1=1
  WHERE task_type = 7 AND is_active = 1 AND @vendor_id IS NOT NULL AND e.[step_name] = 'Transaction_per_vendor'
 UNION ALL
  

  -- Transaction
  SELECT 
      e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'{
    "q": "'+REPLACE(REPLACE(e.[suiteql_query],'##UNIQUEKEY##',CAST(ISNULL((SELECT MAX([uniquekey]) FROM [cus].[TransactionSales] WHERE vendor = t.string_value),0) AS NVARCHAR(MAX))),'##VENDORID##',CAST(t.string_value AS NVARCHAR(MAX))) +'"
}  ' AS [suiteql_query],
       '' AS pre_copy_script,


      (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
            ,','),
            ']}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map
  FROM [cus].[endpoints] e
  INNER JOIN [cus].[string_list_to_table](@vendor_id,',',0) t ON 1=1
  WHERE task_type = 7 AND is_active = 1 AND @vendor_id IS NOT NULL AND e.[step_name] = 'TransactionSales_per_vendor'
   UNION ALL
  

  -- TransactionCashSales
  SELECT 
      e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'{
    "q": "'+REPLACE(e.[suiteql_query],'##UNIQUEKEY##',CAST(ISNULL((SELECT MAX([uniquekey]) FROM [cus].[TransactionCashSales]),0) AS NVARCHAR(MAX))) +'"
}  ' AS [suiteql_query],
       '' AS pre_copy_script,


      (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
            ,','),
            ']}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map
  FROM [cus].[endpoints] e
  WHERE task_type = 7 AND is_active = 1 AND @vendor_id IS NULL AND e.[step_name] = 'TransactionCashSales'  

END



