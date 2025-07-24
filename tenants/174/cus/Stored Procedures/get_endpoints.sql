
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
	  'SELECT ' 
       + COALESCE(e.select_sql, 
                  (SELECT STRING_AGG(QUOTENAME(c.[column_name]), ',') 
                   FROM [dbo].[v_db_object_info] AS c
                   WHERE c.[schema_name] = e.[db_schema]
                   AND c.[object_name] = e.[db_table])) 
       + ' FROM ' + COALESCE(e.from_sql, 'dbo.' + e.[endpoint]) 
       + CASE
		WHEN EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = e.db_schema
          AND TABLE_NAME   = e.db_table
          AND COLUMN_NAME  = 'dataareaid'
		)
		THEN ' WHERE dataareaid IN (' 
         + (
               SELECT STRING_AGG(QUOTENAME(company, ''''), ',')
               FROM cus.DataAreas
               WHERE is_active = 1
           )
         + ')'

    WHEN EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = e.db_schema
          AND TABLE_NAME   = e.db_table
          AND COLUMN_NAME  = 'itemdataareaid'
    )
    THEN ' WHERE itemdataareaid IN (' 
         + (
               SELECT STRING_AGG(QUOTENAME(company, ''''), ',')
               FROM cus.DataAreas
               WHERE is_active = 1
           )
         + ')'

		ELSE ''
	END
       + IIF(e.where_sql IS NOT NULL, 
             CASE 
                WHEN EXISTS (SELECT 1 
                             FROM INFORMATION_SCHEMA.COLUMNS 
                             WHERE TABLE_SCHEMA = e.db_schema
                             AND TABLE_NAME = e.db_table
                             AND (COLUMN_NAME = 'dataareaid' OR COLUMN_NAME = 'itemdataareaid')) 
                THEN ' AND ' + e.where_sql
                ELSE ' WHERE ' + e.where_sql
             END, 
             '') AS query,
       CASE WHEN e.task_type = 0 THEN 'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])
            WHEN e.task_type = 7 THEN  'DELETE FROM '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])+' WHERE CAST(DATEPHYSICAL AS DATE) >= CAST(DATEADD(DAY, -20, GETDATE()) AS DATE) OR CAST(DATEPHYSICAL AS DATE)= ''1900-01-01'''
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

