

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Get erp endpoints
--
-- 2023.07.04.TO   Created
-- ===============================================================================
CREATE PROCEDURE [bc_rest_cus].[get_endpoints_bkp]
(
@CompanyName NVARCHAR(255) = NULL,
@TablePrefix NVARCHAR(255) = NULL,
@TablePostfix NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
  SELECT 
        'bc_rest' AS TableSchema_S
      ,e.[endpoint]
	  ,e.endpoint_filter AS endpoint_filter
      ,'' AS [post_copy_script]
	  ,e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]) AS pre_copy_script
	  ,(SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(
              CONCAT('{"source":{"path":"[''' ,c.[column_name], ''']", "type":"',c.data_type,'"},
                   "sink":{"name":"',   c.[column_name], '", "type":"',c.data_type,'"}}')
            ,','),
            '],"collectionReference": "$[''value'']","mapComplexValuesToString": true}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]) AS column_map
  FROM [bc_rest].[endpoints] e
  WHERE task_type = 0 AND is_active = 1

  UNION ALL
  
  -- ItemLedgerEntry
  SELECT 
        'bc_rest' AS TableSchema_S
      ,e.[endpoint]
	  ,(e.endpoint_filter+'&$filter=EntryNo gt '+(SELECT CAST(MAX([EntryNo]) AS NVARCHAR(50)) FROM bc_rest.item_ledger_entry)) AS endpoint_filter
	  ,'' AS [post_copy_script]
      ,e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'' AS pre_copy_script
      ,(SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(
              CONCAT('{"source":{"path":"[''' ,c.[column_name], ''']", "type":"',c.data_type,'"},
                   "sink":{"name":"',   c.[column_name], '", "type":"',c.data_type,'"}}')
            ,','),
            '],"collectionReference": "$[''value'']","mapComplexValuesToString": true}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]) AS column_map
  FROM [bc_rest].[endpoints] e
  WHERE task_type = 7 AND is_active = 1 AND e.step_name = 'ItemLedgerEntry'

  UNION ALL 

  SELECT 
        'bc_rest' AS TableSchema_S
      ,e.[endpoint]
	  ,e.endpoint_filter AS endpoint_filter
      ,'' AS [post_copy_script]
	  ,e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]) AS pre_copy_script
      ,(SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(
              CONCAT('{"source":{"path":"[''' ,c.[column_name], ''']", "type":"',c.data_type,'"},
                   "sink":{"name":"',   c.[column_name], '", "type":"',c.data_type,'"}}')
            ,','),
            '],"collectionReference": "$[''value'']","mapComplexValuesToString": true}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map
  FROM [bc_rest_cus].[endpoints] e
  WHERE task_type = 0 AND is_active = 1
END


