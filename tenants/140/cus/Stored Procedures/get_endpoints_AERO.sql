CREATE PROCEDURE [cus].[get_endpoints_AERO]
(
@CompanyName NVARCHAR(255) = NULL,
@TablePostfix NVARCHAR(255) = NULL,
@TablePrefix NVARCHAR(255) = NULL
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
		[post_sql] [NVARCHAR](MAX) NULL,
        [Company] [NVARCHAR](15) NULL
	);


	-- Populating the #endpoints temporary table with data from [cus].[endpoints],
	-- and then, if the 'cus.endpoints' table exists, it synchronizes the data in #endpoints with 'cus.endpoints':
	-- 1. Existing rows in #endpoints with matching 'id's are updated with the data from 'cus.endpoints'.
	-- 2. Rows from 'cus.endpoints' that don't have corresponding 'id's in #endpoints are inserted into #endpoints.

INSERT INTO #endpoints ([id], [step_name], [endpoint], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql], [Company])
SELECT [id], [step_name], [endpoint], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql], 'AER' as [Company]
FROM [cus].[endpoints];



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

	-- This SELECT query generates transformation and mapping information for data movement between source (S) and target (T) tables.
	-- For each active row in #endpoints (where is_active = 1), it creates:
	-- 1. TableSchema_S and TableName_S: Source schema and table, hardcoded to 'dbo' and the endpoint name respectively.
	-- 2. TableSchema_T and TableName_T: Target schema and table, derived from db_schema and db_table columns.
	-- 3. query: Constructed SQL query for data extraction, including pre_sql, select_sql, from_sql, where_sql, and post_sql components.
	--    If select_sql is NULL, it fetches column names from v_db_object_info view.
	--    from_sql is coalesced to a default value constructed using @CompanyName and @TablePostfix variables.
	-- 4. pre_copy_script: If task_type is not 7, generates a 'TRUNCATE TABLE' script for the target table.
	-- 5. column_map: JSON object mapping source columns to sink columns used by datafactory. Fetched from v_db_object_info view.


	--Set max entry no for Item Ledger Entry
	/*
    DECLARE @max_entry_no NVARCHAR(255)
	SET @max_entry_no = (SELECT CAST(ISNULL(MAX([Entry No_]),0) AS NVARCHAR(255)) FROM cus.ItemLedgerEntry)
    */

  SELECT
        '' AS TableSchema_S
      ,e.[endpoint] AS TableName_S
      ,e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,IIF(e.pre_sql IS NOT NULL,e.pre_sql+CHAR(10),'')+
	  'SELECT ' + COALESCE(e.select_sql,(SELECT STRING_AGG(QUOTENAME(c.[column_name]),',')
                        FROM [dbo].[v_db_object_info] AS c
                               WHERE  c.[schema_name] = e.[db_schema]
                                  AND c.[object_name] = e.[db_table] and c.[column_name] <> 'Company'))
	   + ' FROM '+COALESCE(e.from_sql,''+QUOTENAME(IIF(@CompanyName IS NOT NULL AND @CompanyName <> '',@CompanyName+'$','')+e.[endpoint]+IIF(@TablePostfix IS NOT NULL AND @TablePostfix <> '','$'+@TablePostfix,'')))
	   + /* IIF(e.task_type = 7, ' WHERE [Entry No_] >'+@max_entry_no +  IIF(e.where_sql IS NOT NULL,' AND '+e.where_sql,''), */ IIF(e.where_sql IS NOT NULL,' WHERE '+e.where_sql,'') /* ) */ AS query,
       IIF(e.post_sql IS NOT NULL,e.post_sql,'') AS post_copy_script,
       e.Company AS Company,
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
  WHERE e.is_active = 1 AND e.[Company] = 'AER'



END
