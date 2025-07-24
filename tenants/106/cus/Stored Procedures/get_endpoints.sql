





CREATE PROCEDURE [cus].[get_endpoints]
(
@CompanyName NVARCHAR(255) = NULL,
@TablePrefix NVARCHAR(255) = NULL,
@TablePostfix NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

  SELECT e.[endpoint] AS [endpoint_id]
	    ,e.[endpoint_body] AS [body]
	    ,e.[db_schema] AS TableSchema_T
	    ,e.[db_table] AS TableName_T
	    ,IIF(e.pre_sql IS NOT NULL,e.pre_sql+CHAR(10),'')+	  
	    NULL AS query,
        IIF(e.task_type <> 7, 
			'IF OBJECT_ID('''+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])+''', ''U'') IS NOT NULL BEGIN TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])+' END',
			'delete from '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])+' WHERE '+
				CASE WHEN [db_table] = 'Sales_History' THEN '[dh_datetime]'
					 WHEN [db_table] = 'Stock_History' THEN '[date]'
					 WHEN [db_table] = 'BOM_Consumption_History' THEN '[vts_datetime]'
				ELSE '' END+' >= CAST(GETDATE() - CAST(10 AS int) AS DATE)') AS pre_copy_script,
	    IIF(e.post_sql IS NOT NULL,e.post_sql,'') AS post_copy_script,
	    (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
	   				STRING_AGG(CAST(
	   				  CONCAT('{"source":{"name":"' ,c.[column_name], '"},
	   					   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
	   				,','),
	   				']}') AS json_output
			FROM [dbo].[v_db_object_info] AS c
		   WHERE c.[schema_name] = e.[db_schema]
				 AND c.[object_name] = e.[db_table]) AS column_map
    FROM cus.endpoints e
   WHERE e.is_active = 1

  

END

