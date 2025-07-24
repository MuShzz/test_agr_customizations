
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Get erp endpoints
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
            'dbo' AS TableSchema_S
          ,e.[endpoint] AS TableName_S
          ,e.[db_schema] AS TableSchema_T
          ,e.[db_table] AS TableName_T
          ,'SELECT ' + (SELECT STRING_AGG(QUOTENAME(c.[column_name]),',') 
                            FROM [dbo].[v_db_object_info] AS c
                                   WHERE  c.[schema_name] = e.[db_schema]
                                      AND c.[object_name] = e.[db_table])
	       + ' FROM dbo.'+QUOTENAME(e.[endpoint]) AS query,
           'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]) AS pre_copy_script,
	       e.endpoint_filter AS endpoint_filter,

	    (SELECT CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
                STRING_AGG(CAST(
                  CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                       "sink":{"name":"',  c.[column_name], '"}}') AS NVARCHAR(MAX))
                ,','),
                ']',',"collectionReference": "$[', CHAR(39), 'value', CHAR(39),']" }') AS json_output
           FROM [dbo].[v_db_object_info] AS c
           WHERE  c.[schema_name] = e.[db_schema]
              AND c.[object_name] = e.[db_table]
              ) AS column_map,
            comp.[company] AS company_name,
            comp.erp_endpoint,
            comp.erp_token,
            comp.erp_user,
            comp.erp_secret,
            comp.erp_scope,
            ROW_NUMBER () OVER (PARTITION BY e.db_schema, e.db_table ORDER BY comp.[company]) AS step_no
            FROM [cus].[endpoints] e
      INNER JOIN [cus].companies comp ON 1=1
      WHERE task_type = 0 AND e.is_active = 1 

      UNION ALL
  
      -- ItemLedgerEntry
      SELECT 
            'dbo' AS TableSchema_S
          ,e.[endpoint] AS TableName_S
          ,e.[db_schema] AS TableSchema_T
          ,e.[db_table] AS TableName_T
          ,'SELECT ' + (SELECT STRING_AGG(QUOTENAME(c.[column_name]),',') 
                            FROM [dbo].[v_db_object_info] AS c
                                   WHERE  c.[schema_name] = e.[db_schema]
                                      AND c.[object_name] = e.[db_table])
           + ' FROM dbo.'+QUOTENAME(ISNULL(@CompanyName,'')+'$'+e.[endpoint])
           + ' WHERE [Entry No_] > '+CAST(ISNULL((SELECT MAX([EntryNo]) FROM [cus].[item_ledger_entry] WHERE COMPANY = comp.[company]),0) AS NVARCHAR(MAX))
           AS query,
           '' AS pre_copy_script,
	     (e.endpoint_filter+'&$filter=EntryNo gt '+(SELECT CAST(MAX(EntryNo) AS NVARCHAR(50)) FROM [cus].[item_ledger_entry] WHERE COMPANY = comp.[company])) AS endpoint_filter,
  
          (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
                STRING_AGG(CAST(
                  CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                       "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
                ,','),
                ']}') AS json_output
           FROM [dbo].[v_db_object_info] AS c
           WHERE  c.[schema_name] = e.[db_schema]
              AND c.[object_name] = e.[db_table]
              ) AS column_map,
            comp.[company] AS company_name,
            comp.erp_endpoint,
            comp.erp_token,
            comp.erp_user,
            comp.erp_secret,
            comp.erp_scope,
            2 AS step_no
            FROM [cus].[endpoints] e
      INNER JOIN [cus].companies comp ON 1=1
      WHERE e.task_type = 7 AND e.is_active = 1 AND e.step_name = 'ItemLedgerEntry'
) t1 ORDER BY t1.step_no ASC

END


