






CREATE PROCEDURE [cus].[get_endpoints]
(
@CompanyName NVARCHAR(255) = NULL,
@TablePrefix NVARCHAR(255) = NULL,
@TablePostfix NVARCHAR(255) = NULL
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
		[db_schema] [NVARCHAR](50) NULL,
		[db_table] [NVARCHAR](500) NOT NULL,
		[priority] [INT] NOT NULL,
		[is_active] [BIT] NOT NULL,
		[pre_sql_exec] [NVARCHAR](MAX) NULL,
		[pre_sql] [NVARCHAR](MAX) NULL,
		[select_sql] [NVARCHAR](MAX) NULL,
		[from_sql] [NVARCHAR](MAX) NULL,
		[where_sql] [NVARCHAR](MAX) NULL,
		[post_sql] [NVARCHAR](MAX) NULL
	);


	-- Populating the #endpoints temporary table with data from [cus].[endpoints], 
	-- and then, if the 'cus.endpoints' table exists, it synchronizes the data in #endpoints with 'cus.endpoints':
	-- 1. Existing rows in #endpoints with matching 'id's are updated with the data from 'cus.endpoints'.
	-- 2. Rows from 'cus.endpoints' that don't have corresponding 'id's in #endpoints are inserted into #endpoints.

INSERT INTO #endpoints ([id], [step_name], [endpoint], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql])
SELECT [id], [step_name], [endpoint], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql]
FROM [cus].[endpoints] WHERE is_active = 1;


	IF OBJECT_ID('cus.endpoints', 'U') IS NOT NULL
	BEGIN
		-- Update existing rows
		EXEC('
			UPDATE e
			SET 
				e.[step_name] = ce.[step_name],
				e.[endpoint] = ce.[endpoint],
				e.[task_type] = ce.[task_type],
				e.[db_schema] = ce.[db_schema],
				e.[db_table] = ce.[db_table],
				e.[priority] = ce.[priority],
				e.[is_active] = ce.[is_active],
				e.[pre_sql_exec] = ce.[pre_sql_exec],
				e.[pre_sql] = ce.[pre_sql],
				e.[select_sql] = ce.[select_sql],
				e.[from_sql] = ce.[from_sql],
				e.[where_sql] = ce.[where_sql],
				e.[post_sql] = ce.[post_sql]
			FROM #endpoints e
			INNER JOIN cus.endpoints ce ON e.[id] = ce.[id]
		');

		-- Insert new rows
		EXEC('
			INSERT INTO #endpoints ([id], [step_name], [endpoint], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql])
			SELECT [id], [step_name], [endpoint], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql]
			FROM cus.endpoints ce
			WHERE NOT EXISTS (SELECT 1 FROM #endpoints e WHERE e.[id] = ce.[id])
		');
	END;

	-- Iterating over all rows in the #endpoints temporary table where the pre_sql_exec column is not null or empty. 
	-- For each of these rows, it executes the dynamic SQL contained in pre_sql_exec. 
	-- The result of this execution is then updated into the pre_sql column of the corresponding row in #endpoints.

	-- Declare variables
	DECLARE @id INT, @preSqlExec NVARCHAR(MAX), @pre_sql NVARCHAR(MAX), @sql NVARCHAR(MAX), @params NVARCHAR(MAX), @output NVARCHAR(MAX)

	-- Declare cursor
	DECLARE preSqlExec_cursor CURSOR FOR
	SELECT [id], [pre_sql_exec]
	FROM #endpoints
	WHERE [pre_sql_exec] IS NOT NULL AND [pre_sql_exec] <> ''

	-- Open cursor and fetch the first row
	OPEN preSqlExec_cursor
	FETCH NEXT FROM preSqlExec_cursor INTO @id, @preSqlExec

	-- Loop through the rows
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Set the SQL to be executed and the parameters
		SET @sql = @preSqlExec
		SET @params = N'@pre_sql NVARCHAR(MAX) OUTPUT'
        
		-- Execute the dynamic SQL
		EXEC sp_executesql @sql, @params, @pre_sql OUTPUT

		-- Update the pre_sql column in #endpoints
		UPDATE #endpoints
		SET [pre_sql] = @pre_sql
		WHERE [id] = @id

		-- Fetch the next row
		FETCH NEXT FROM preSqlExec_cursor INTO @id, @preSqlExec
	END
    


	-- Close and deallocate the cursor
	CLOSE preSqlExec_cursor
	DEALLOCATE preSqlExec_cursor

  SELECT 
        'dbo' AS TableSchema_S
      ,e.[endpoint] AS TableName_S
      ,e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,e.pre_sql
      ,IIF(e.pre_sql IS NOT NULL,e.pre_sql+CHAR(10),'')+	  
	  'SELECT ' + COALESCE(e.select_sql,(SELECT STRING_AGG(QUOTENAME(c.[column_name]),',') 
                        FROM [dbo].[v_db_object_info] AS c
                               WHERE  c.[schema_name] = e.[db_schema]
                                  AND c.[object_name] = e.[db_table]))
	   + ' FROM '+COALESCE(e.from_sql,'dbo.'+e.[endpoint]) 
 
	   + IIF(e.where_sql IS NOT NULL,' WHERE '+e.where_sql,'') AS query,
       CASE WHEN e.task_type = 0 THEN 'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])
            --WHEN e.task_type = 7 THEN  'delete from  '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])+' where datephysical = (SELECT MAX(datephysical) FROM '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])+')'
       END AS pre_copy_script,
	   IIF(e.post_sql IS NOT NULL,e.post_sql,'') AS post_copy_script,
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
  FROM #endpoints e
  WHERE e.is_active = 1

  

END

