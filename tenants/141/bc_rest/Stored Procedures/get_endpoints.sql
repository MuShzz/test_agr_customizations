/****** Object:  StoredProcedure [bc_rest].[get_endpoints]    Script Date: 6/4/2024 2:22:37 PM ******/



CREATE PROCEDURE [bc_rest_cus].[get_endpoints]
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
		[base_url]			[NVARCHAR] (1000)	NULL,
		[endpoint]			[NVARCHAR](100)		NULL,
		[task_type]			[INT]				NOT NULL,
		[db_schema]			[NVARCHAR](50)		NOT NULL,
		[db_table]			[NVARCHAR](500)		NOT NULL,
		[endpoint_filter]	[NVARCHAR](2000)	NULL,
		[priority]			[INT]				NOT NULL,
		[is_active]			[BIT]				NOT NULL,
		[post_sql]			[NVARCHAR](MAX)		NULL
	);


	-- Populating the #endpoints temporary table with data from [bc_sql].[endpoints], 
	-- and then, if the 'cus.endpoints' table exists, it synchronizes the data in #endpoints with 'cus.endpoints':
	-- 1. Existing rows in #endpoints with matching 'id's are updated with the data from 'cus.endpoints'.
	-- 2. Rows from 'cus.endpoints' that don't have corresponding 'id's in #endpoints are inserted into #endpoints.

	INSERT INTO #endpoints ([id], [step_name], [base_url], [endpoint], [endpoint_filter], [task_type], [db_schema], [db_table], [priority], [is_active], [post_sql])
	SELECT [id], [step_name], '' AS [base_url], [endpoint], [endpoint_filter], [task_type], [db_schema], [db_table], [priority], [is_active], [post_sql]
	FROM [bc_rest].[endpoints]

	
	IF OBJECT_ID('bc_rest_cus.endpoints', 'U') IS NOT NULL
	BEGIN
		-- Update existing rows
		EXEC('
			UPDATE e
			SET 
				e.[step_name]			= ce.[step_name],
				e.[base_url]			= ce.[base_url],
				e.[endpoint]			= ce.[endpoint],
				e.[endpoint_filter]		= ce.[endpoint_filter],
				e.[task_type]			= ce.[task_type],
				e.[db_schema]			= ce.[db_schema],
				e.[db_table]			= ce.[db_table],
				e.[priority]			= ce.[priority],
				e.[is_active]			= ce.[is_active],
				e.[post_sql]			= ce.[post_sql]
			FROM #endpoints e
			INNER JOIN bc_rest_cus.endpoints ce ON e.[id] = ce.[id]
		');

		-- Insert new rows
		EXEC('
			INSERT INTO #endpoints ([id], [step_name], [base_url], [endpoint], [endpoint_filter], [task_type], [db_schema], [db_table], [priority], [is_active], [post_sql])
			SELECT [id], [step_name], [base_url], [endpoint], [endpoint_filter], [task_type], [db_schema], [db_table], [priority], [is_active], [post_sql]
			FROM [bc_rest_cus].[endpoints] ce
			WHERE NOT EXISTS (SELECT 1 FROM #endpoints e WHERE e.[id] = ce.[id])
		');
	END;


	-- This SELECT query generates transformation and mapping information for data movement between source (S) and target (T) tables.
	-- For each active row in #endpoints (where is_active = 1), it creates:
	-- 1. TableSchema_S and TableName_S: Source schema and table, hardcoded to 'dbo' and the endpoint name respectively.
	-- 2. TableSchema_T and TableName_T: Target schema and table, derived from db_schema and db_table columns.
	-- 3. query: Constructed SQL query for data extraction, including pre_sql, select_sql, from_sql, where_sql, and post_sql components.
	--    If select_sql is NULL, it fetches column names from v_db_object_info view.
	--    from_sql is coalesced to a default value constructed using @CompanyName and @TablePostfix variables.
	-- 4. pre_copy_script: If task_type is not 1, generates a 'TRUNCATE TABLE' script for the target table.
	-- 5. column_map: JSON object mapping source columns to sink columns used by datafactory. Fetched from v_db_object_info view.

	
	--Set max entry no for Item Ledger Entry
	DECLARE @max_entry_no NVARCHAR(255) 
	SET @max_entry_no = (SELECT CAST(ISNULL(MAX([EntryNo]),0) AS NVARCHAR(255)) FROM [bc_rest].[item_ledger_entry])

	SELECT 
        'bc_rest'			AS TableSchema_S
	  ,e.base_url			AS [baseURL]
      ,e.[endpoint]			AS [endpoint]
      ,e.[endpoint_filter] + IIF(e.task_type = 1,'&$filter=EntryNo gt '+@max_entry_no,'')	AS [endpoint_filter]
	  ,e.[db_schema]		AS TableSchema_T
      ,e.[db_table]			AS TableName_T
	  ,''					AS query
	  ,IIF(e.task_type <> 1, 'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]),'') AS pre_copy_script
	  ,IIF(e.post_sql IS NOT NULL, e.post_sql,'') AS post_copy_script,

      (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"path":"[''' ,c.[column_name], ''']", "type":"',c.data_type,'"},
                   "sink":{"name":"',   c.[column_name], '", "type":"',c.data_type,'"}}') AS NVARCHAR(MAX))
            ,','),
            '],"collectionReference": "$[''value'']","mapComplexValuesToString": true}') AS json_output
       FROM [dbo].[v_db_object_info] AS c
       WHERE  c.[schema_name] = e.[db_schema]
          AND c.[object_name] = e.[db_table]
          ) AS column_map
  FROM #endpoints e
  WHERE e.is_active = 1

END

