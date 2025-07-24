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
		[endpoint_filter]	[NVARCHAR](2000)	NULL,
		[task_type]			[INT]				NOT NULL,
		[db_schema]			[NVARCHAR](50)		NOT NULL,
		[db_table]			[NVARCHAR](500)		NOT NULL,
		[db_table_destiny]  [NVARCHAR](500)		NULL,
		[table_array]		[NVARCHAR](100)		 NULL,
		[priority]			[INT]				NOT NULL,
		[is_active]			[BIT]				NOT NULL,
		[collection]		[NVARCHAR](2000)		NULL,
		[keyarray]			[NVARCHAR](50)		NULL,
		[iq_date_field]		[NVARCHAR](20)		NULL,
		[date_field]		[NVARCHAR](20)		NULL,
	);

	INSERT INTO #endpoints ([id], [step_name], [endpoint], [endpoint_filter], [task_type], [db_schema], [db_table],[db_table_destiny],[table_array], [priority], [is_active], [collection], [keyarray], [iq_date_field], [date_field])
	SELECT [id], [step_name], [endpoint], [endpoint_filter], [task_type], [db_schema], [db_table],[db_table_destiny],[table_array], [priority], [is_active], [collection], [keyarray], [iq_date_field], [date_field]
	FROM [cus].[endpoints]

	
	IF OBJECT_ID('iq_cus.endpoints', 'U') IS NOT NULL
	BEGIN
		-- Update existing rows
		EXEC('
			UPDATE e
			SET 
				e.[step_name]			= ce.[step_name],
				e.[endpoint]			= ce.[endpoint],
				e.[endpoint_filter]		= ce.[endpoint_filter],
				e.[task_type]			= ce.[task_type],
				e.[db_schema]			= ce.[db_schema],
				e.[db_table]			= ce.[db_table],
				e.[db_table_destiny]	= ce.[db_table_destiny], 
				e.[table_array]			= ce.[table_array], 
				e.[priority]			= ce.[priority],
				e.[is_active]			= ce.[is_active],
				e.[collection]			= ce.[collection],
				e.[keyarray]			= ce.[keyarray],
				e.[iq_date_field]		= ce.[iq_date_field],
				e.[date_field]			= ce.[date_field]
			FROM #endpoints e
			INNER JOIN iq_cus.endpoints ce ON e.[id] = ce.[id]
		');

		-- Insert new rows
		EXEC('
			INSERT INTO #endpoints ([id], [step_name], [endpoint], [endpoint_filter], [task_type],[table_array], [db_schema], [db_table],[db_table_destiny], [priority], [is_active], [collection], [keyarray], [iq_date_field], [date_field])
			SELECT [id], [step_name], [endpoint], [endpoint_filter], [task_type],[table_array], [db_schema], [db_table],[db_table_destiny], [priority], [is_active], [collection], [keyarray], [iq_date_field], [date_field]
			FROM [iq_cus].[endpoints] ce
			WHERE NOT EXISTS (SELECT 1 FROM #endpoints e WHERE e.[id] = ce.[id])
		');
	END;

	IF @CompanyName IS NULL OR @CompanyName = ''
		BEGIN 
			DECLARE @id		INT,		   @step_name	NVARCHAR(50),	@db_table	NVARCHAR(50), @db_schema NVARCHAR(50), @iq_date_field NVARCHAR(20), @date_field NVARCHAR(20),
					@sql	NVARCHAR(MAX), @params		NVARCHAR(MAX),	@pre_sql	NVARCHAR(MAX)

			-- Declare cursor
			DECLARE preSqlExec_cursor CURSOR FORWARD_ONLY READ_ONLY LOCAL FOR
			SELECT [id], [step_name],[db_table], [db_schema], [iq_date_field], [date_field]
			FROM #endpoints
			WHERE [task_type] = 7 AND is_active = 1

			-- Open cursor and fetch the first row
			OPEN preSqlExec_cursor
			FETCH NEXT FROM preSqlExec_cursor INTO @id, @step_name, @db_table, @db_schema, @iq_date_field, @date_field

			-- SELECT @pre_sql = 'DECLARE @max_entry_no BIGINT = ' + CAST(ISNULL((SELECT MAX([Entry No_]) FROM [bc_sql].[ItemLedgerEntry]),0) AS NVARCHAR(MAX))
			-- Loop through the rows
			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- Set the SQL to be executed and the parameters
				SET @sql = 'SELECT @pre_sql = ISNULL((select max(cast('+@date_field+' as date)) as max_date from '+@db_schema+'.'+@db_table+'),''2000-01-01'')'
				SET @params = N'@pre_sql NVARCHAR(MAX) OUTPUT'

				PRINT @sql
    
				-- Execute the dynamic SQL
				EXEC sp_executesql @sql, @params, @pre_sql OUTPUT

				-- Update the pre_sql column in #endpoints
				UPDATE #endpoints
				SET [endpoint_filter] = ISNULL([endpoint_filter],'')+'&'+@iq_date_field+'[gte]='+@pre_sql
				WHERE [id] = @id

				-- Fetch the next row
				FETCH NEXT FROM preSqlExec_cursor INTO @id, @step_name, @db_table, @db_schema, @iq_date_field, @date_field
			END

			CLOSE preSqlExec_cursor
		END
 
    SELECT 
		   e.[endpoint]
		  ,e.[endpoint_filter]
		  ,e.[db_schema]
		  ,e.[db_table]
		  ,e.[db_table_destiny]
		  ,e.[table_array]
		  ,e.[keyarray]
		 -- CASE WHEN e.[keyarray] IS NULL THEN
			--	(SELECT [column_name] FROM [dbo].[v_db_object_info] AS c
			--	  WHERE c.[schema_name] = e.[db_schema]
			--	    AND c.[object_name] = e.[db_table]
			--	    AND c.column_id = 1)
			--ELSE e.[keyarray]
			--END AS [keyarray]
		  --ISNULL(e.[keyarray],'') AS [keyarray]
		  ,e.[iq_date_field]
		  ,e.[date_field]
		  ,IIF(e.task_type <> 7, 
				'TRUNCATE TABLE ' + QUOTENAME(e.[db_schema]) + '.' + QUOTENAME(e.[db_table]) + 
				CASE WHEN e.[db_table_destiny] IS NOT NULL THEN 
					'; TRUNCATE TABLE ' + QUOTENAME(e.[db_schema]) + '.' + QUOTENAME(e.[db_table_destiny]) 
				ELSE '' 
				END, 
				''
			) AS pre_copy_script


		  ,(SELECT  CONCAT(
                '{"type": "TabularTranslator", "mappings": ', '[',
                REPLACE(
                    CAST(
                        STRING_AGG(
                            CAST(
                                CONCAT(
                                    '{"source":{"path":"',
                                   CASE 
										WHEN COLUMN_NAME LIKE '$%' THEN 
											CASE 
												WHEN COLUMN_NAME LIKE '%.%' THEN CONCAT('[''', REPLACE(SUBSTRING(COLUMN_NAME, 2, LEN(COLUMN_NAME) - 1), '.', ''']['''), ''']')
												ELSE SUBSTRING(COLUMN_NAME, 2, LEN(COLUMN_NAME) - 1)
											END
										WHEN COLUMN_NAME LIKE '%.%' THEN CONCAT('[''', REPLACE(COLUMN_NAME, '.', ''']['''), ''']')
										ELSE COLUMN_NAME
									END
								,
                                    '", "type":"', c.data_type, '"}, "sink":{"name":"', c.[column_name], '", "type":"', c.data_type, '"}}'
                                ) AS NVARCHAR(MAX)
                            ),
                            ','
                        ) AS NVARCHAR(MAX)
                    ),
                    '[''' + ISNULL(e.[collection], '') + ''']', ''
                ),
                IIF(e.collection IS NULL, ']}', '], "collectionReference": "$.' + e.[collection]+'", "mapComplexValuesToString": true}')
            ) AS json_output
		   FROM [dbo].[v_db_object_info] AS c
		   WHERE  c.[schema_name] = e.[db_schema]
			  AND c.[object_name] = e.[db_table]
			  ) AS column_map
	  FROM #endpoints e
	  WHERE e.is_active = 1 AND (e.step_name = ISNULL(@CompanyName,e.step_name) OR @CompanyName = '')

END

