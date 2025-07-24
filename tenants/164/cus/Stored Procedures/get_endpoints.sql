
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Get erp endpoints for bc public cloud multicompany
--
-- 2023.07.04.TO   Created
-- ===============================================================================

CREATE PROCEDURE [cus].[get_endpoints]
(
	@CompanyName NVARCHAR(255) = NULL,
	@TablePrefix NVARCHAR(255) = NULL,
	@TablePostfix NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

  SELECT * FROM ( 	
      SELECT 
            e.[endpoint]
          ,e.[db_schema] AS TableSchema_T
          ,e.[db_table] AS TableName_T
	      ,e.endpoint_filter AS endpoint_filter

	      , (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"path":"[''' ,c.[column_name], ''']"},
                   "sink":{"name":"',   c.[column_name], '", "type":"',c.data_type,'"}}') AS NVARCHAR(MAX))
            ,','),
            '],"collectionReference": "$[''value'']","mapComplexValuesToString": true}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map,
			comp.[company_name],
            comp.[company] AS [Company]
            FROM [cus].[endpoints] e
      INNER JOIN [cus].companies comp ON 1=1
      WHERE e.task_type = 0 
	    AND e.is_active = 1 
	    AND e.db_table NOT IN ('agr_api_order_lines','agr_api_order_header','agr_setup','agr_log')

      UNION ALL
  
      -- ItemLedgerEntry
      SELECT 
           e.[endpoint]
          ,e.[db_schema] AS TableSchema_T
          ,e.[db_table] AS TableName_T
	      ,(e.endpoint_filter+'&$filter=EntryNo gt '+(SELECT CAST(MAX(EntryNo) AS NVARCHAR(50)) FROM [cus].[item_ledger_entry] WHERE COMPANY = comp.[company])) AS endpoint_filter

          ,(SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"path":"[''' ,c.[column_name], ''']", "type":"',c.data_type,'"},
                   "sink":{"name":"',   c.[column_name], '", "type":"',c.data_type,'"}}') AS NVARCHAR(MAX))
            ,','),
            '],"collectionReference": "$[''value'']","mapComplexValuesToString": true}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map,
			comp.[company_name],
            comp.[company] AS [Company]
            FROM cus.[endpoints] e
      INNER JOIN [cus].companies comp ON 1=1
      WHERE e.task_type = 1 
	    AND e.is_active = 1 
	    AND e.step_name = 'ItemLedgerEntry' 
	    AND e.db_table NOT IN ('agr_api_order_lines','agr_api_order_header','agr_setup','agr_log')
) t1

END


