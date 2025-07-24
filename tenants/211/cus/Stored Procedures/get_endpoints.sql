CREATE PROCEDURE [cus].[get_endpoints]
(
@CompanyName NVARCHAR(255) = NULL,
@TablePostfix NVARCHAR(255) = NULL,
@TablePrefix NVARCHAR(255) = NULL,
@CollectionReference NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	DROP TABLE IF EXISTS #endpoints

	CREATE TABLE #endpoints
	(
		[id] [INT] NOT NULL,
		[step_name] [NVARCHAR](50) NOT NULL,
		[endpoint] [NVARCHAR](100) NULL,
		[task_type] [INT] NOT NULL,
		[source_schema] [NVARCHAR](50) NULL,
		[source_table] [NVARCHAR](500) NULL,
		[target_schema] [NVARCHAR](50) NULL,
		[target_table] [NVARCHAR](50) NULL,
		[endpoint_filter] [NVARCHAR](500) NULL,
		[priority] [INT] NOT NULL,
		[is_active] [BIT] NOT NULL,
		[where_sql] [NVARCHAR](MAX) NULL,
		[post_sql] [NVARCHAR](MAX) NULL,
		[collectionReference] [NVARCHAR](255) NULL,
		[key] [NVARCHAR](255) NULL
	);

	-- Populating the #endpoints temporary table with data from [bc_sql].[endpoints], 
	-- and then, if the 'cus.endpoints' table exists, it synchronizes the data in #endpoints with 'cus.endpoints':
	-- 1. Existing rows in #endpoints with matching 'id's are updated with the data from 'cus.endpoints'.
	-- 2. Rows from 'cus.endpoints' that don't have corresponding 'id's in #endpoints are inserted into #endpoints.

	INSERT INTO #endpoints ([id], [step_name], [endpoint], [task_type], [source_schema], [source_table], [target_schema], [target_table], [endpoint_filter], [priority], [is_active], [post_sql], [where_sql],[collectionReference], [key])
	SELECT [id], [step_name], [endpoint], [task_type], [source_schema], [source_table], [target_schema], [target_table], [endpoint_filter], [priority], [is_active], [post_sql], [where_sql],[collectionReference], [key]
	FROM [cus].[endpoints];

		--Set max entry no for Item Ledger Entry

	SELECT 
       e.[endpoint]	                                                                    AS [endpoint]
      ,e.[endpoint_filter]																					AS [endpoint_filter]
	  ,e.[target_schema]					                                                                AS TableSchema_T
      ,e.[target_table]						                                                                AS TableName_T

	  ---------------------------- QUERY --------------------------------------------

	  ,NULL AS query

	  ---------------------------- END QUERY --------------------------------------------

	  ,IIF(e.task_type <> 7, 'TRUNCATE TABLE '+QUOTENAME(e.[target_schema])+'.'+QUOTENAME(e.[target_table]),'')     AS pre_copy_script
	  ,IIF(e.post_sql IS NOT NULL, e.post_sql,'')                                                           AS post_copy_script,

      (SELECT  CAST(
		
		 
		  STRING_AGG(
			CONCAT(
			  '("', c.[column_name], '"',
			  ',"', c.[column_name], '"',',"',c.data_type, '")'
			), ','
		  )
		 AS NVARCHAR(MAX)) AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[target_schema]
          AND c.[object_name] = e.[target_table]
          ) AS column_map,
		(SELECT  CAST(
		CONCAT(
		  '{"type": "TabularTranslator", "mappings": [',
		  STRING_AGG(
			CONCAT(
			  '{"source":{"path":"[''', c.[column_name], ''']"}, ',
			  '"sink":{"name":"', c.[column_name], '"}}'
			), ','
		  ),
		  '],"mapComplexValuesToString": true}'
		) AS NVARCHAR(MAX)) AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[target_schema]
          AND c.[object_name] = e.[target_table]
          ) AS json_output,
		  e.[key] AS [key]
		
  FROM #endpoints e
  WHERE e.is_active = 1 
  
END

