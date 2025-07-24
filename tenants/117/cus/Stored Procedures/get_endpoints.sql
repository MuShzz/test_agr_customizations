



CREATE PROCEDURE [cus].[get_endpoints]
(
	@CompanyName NVARCHAR(255)	= NULL,
	@TablePostfix NVARCHAR(255) = NULL,
	@TablePrefix NVARCHAR(255)	= NULL
)
AS
BEGIN
	SET NOCOUNT ON

	DROP TABLE IF EXISTS #endpoints

	CREATE TABLE #endpoints
	(
		[id]				[INT]				NOT NULL,
		[step_name]			[NVARCHAR](50)		NOT NULL,
		[endpoint]			[NVARCHAR](100)		NULL,
		[task_type]			[INT]				NOT NULL,
		[source_schema]		[NVARCHAR](50)		NOT NULL,
		[source_table]		[NVARCHAR](500)		NOT NULL,
		[target_schema]		[NVARCHAR](50)		NOT NULL,
		[target_table]		[NVARCHAR](500)		NOT NULL,
		[endpoint_filter]	[NVARCHAR](2000)	NULL,
		[priority]			[INT]				NOT NULL,
		[is_active]			[BIT]				NOT NULL,
		[post_sql]			[NVARCHAR](MAX)		NULL,
		[where_sql]			[NVARCHAR](500)		NULL
	);


	INSERT INTO #endpoints ([id], [step_name], [endpoint], [endpoint_filter], [task_type], [source_schema], [source_table], [target_schema], [target_table], [priority], [is_active], [post_sql], [where_sql])
	SELECT [id], [step_name], [endpoint], [endpoint_filter], [task_type], [source_schema], [source_table], [target_schema], [target_table], [priority], [is_active], [post_sql], [where_sql]
	FROM [cus].[endpoints] WHERE [is_active] = 1

	
	--Set max entry no for Item Ledger Entry
	DECLARE @max_entry_no NVARCHAR(255) 
	SET @max_entry_no = (SELECT CAST(ISNULL(MAX([TranNum]),0) AS NVARCHAR(255)) FROM [cus].[PartTran])

	SELECT 
       @CompanyName+'/'+e.[endpoint]	                                                                    AS [endpoint]
      ,e.[endpoint_filter] + IIF(e.task_type = 7,'&$filter=TranNum gt '+@max_entry_no,'')	                AS [endpoint_filter]
	  ,e.[target_schema]					                                                                AS TableSchema_T
      ,e.[target_table]						                                                                AS TableName_T

	  ---------------------------- QUERY --------------------------------------------

	  ,'SELECT ' + (SELECT STRING_AGG(QUOTENAME(c.[column_name]),',') 
                        FROM [dbo].[v_db_object_info] AS c
                               WHERE  c.[schema_name] = e.[target_schema]
                                  AND c.[object_name] = e.[target_table]
								  AND c.[column_name] <> 'Plant1' )
	   + ' FROM '+ISNULL(QUOTENAME(e.[source_schema])+'.','[dbo].')+QUOTENAME(e.[source_table])
	   + IIF(e.task_type = 7, 
			 ' WHERE [Company] = '''+@CompanyName+''' and [TranNum] >'+@max_entry_no + ISNULL(' AND '+e.[where_sql],''), 
			 ISNULL(' WHERE '+e.[where_sql]+' and [Company] = '''+@CompanyName+'''',' WHERE [Company] = '''+@CompanyName+'''')) AS query

	  ---------------------------- END QUERY --------------------------------------------

	  ,IIF(e.task_type <> 7, 'TRUNCATE TABLE '+QUOTENAME(e.[target_schema])+'.'+QUOTENAME(e.[target_table]),'')     AS pre_copy_script
	  ,IIF(e.post_sql IS NOT NULL, e.post_sql,'')                                                           AS post_copy_script,

      (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(
              CONCAT('{"source":{"path":"[''' ,c.[column_name], ''']", "type":"',c.data_type,'"},
                   "sink":{"name":"',   c.[column_name], '", "type":"',c.data_type,'"}}')
            ,','),
            '],"collectionReference": "$[''value'']","mapComplexValuesToString": true}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[target_schema]
          AND c.[object_name] = e.[target_table]
          ) AS column_map
  FROM #endpoints e
  WHERE e.is_active = 1 
  
END

