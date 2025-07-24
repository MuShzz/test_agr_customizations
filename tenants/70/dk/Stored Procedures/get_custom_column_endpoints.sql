

CREATE PROCEDURE [dk_cus].[get_custom_column_endpoints]

AS
BEGIN
	SET NOCOUNT ON

	DROP TABLE IF EXISTS #customcolumnendpoints

	CREATE TABLE #customcolumnendpoints
	(
	[id] [INT] NOT NULL,
	[step_name] [NVARCHAR](50) NOT NULL,
	[custom_column_id] [INT] NOT NULL,
	[custom_column_type] [NVARCHAR](50) NOT NULL,
	[source_object_schema] [NVARCHAR](255) NULL,
	[source_object_name] [NVARCHAR](255) NULL,
	[source_column_name] [NVARCHAR](255) NULL,
	[item_no_join_column] [NVARCHAR](255) NULL,
	[location_no_join_column] [NVARCHAR](255) NULL,
	[is_active] [BIT] NOT NULL,
	[pre_sql_exec] [NVARCHAR](MAX) NULL,
	[pre_sql] [NVARCHAR](MAX) NULL,
	[select_sql] [NVARCHAR](MAX) NULL,
	[from_sql] [NVARCHAR](MAX) NULL,
	[where_sql] [NVARCHAR](MAX) NULL,
	[post_sql] [NVARCHAR](MAX) NULL,
	);


	-- Populating the #endpoints temporary table with data from [bc_sql].[endpoints], 
	-- and then, if the 'cus.endpoints' table exists, it synchronizes the data in #endpoints with 'cus.endpoints':
	-- 1. Existing rows in #endpoints with matching 'id's are updated with the data from 'cus.endpoints'.
	-- 2. Rows from 'cus.endpoints' that don't have corresponding 'id's in #endpoints are inserted into #endpoints.

INSERT INTO #customcolumnendpoints ([id], [step_name], [custom_column_id], [custom_column_type], [source_object_schema], [source_object_name], [source_column_name], [item_no_join_column], [location_no_join_column], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql])
SELECT [id]
	  ,[step_name]
      ,[custom_column_id]
	  ,[custom_column_type]
      ,[source_object_schema]
      ,[source_object_name]
      ,[source_column_name]
	  ,[item_no_join_column]
	  ,[location_no_join_column]
      ,[is_active]
      ,[pre_sql_exec]
      ,[pre_sql]
      ,[select_sql]
      ,[from_sql]
      ,[where_sql]
      ,[post_sql]
FROM [dk_cus].[custom_column_endpoints]
where [is_active] = 1;

	-- Iterating over all rows in the #endpoints temporary table where the pre_sql_exec column is not null or empty. 
	-- For each of these rows, it executes the dynamic SQL contained in pre_sql_exec. 
	-- The result of this execution is then updated into the pre_sql column of the corresponding row in #endpoints.

	-- Declare variables
	DECLARE @id INT, @preSqlExec NVARCHAR(MAX), @pre_sql NVARCHAR(MAX), @sql NVARCHAR(MAX), @params NVARCHAR(MAX), @output NVARCHAR(MAX)

	-- Declare cursor
	DECLARE preSqlExec_cursor CURSOR FOR
	SELECT [id], [pre_sql_exec]
	FROM #customcolumnendpoints
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
		UPDATE #customcolumnendpoints
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
	DECLARE @max_entry_no NVARCHAR(255) 
	SET @max_entry_no = (SELECT CAST(ISNULL(MAX([Entry No_]),0) AS NVARCHAR(255)) FROM bc_sql.ItemLedgerEntry)


	SELECT e.step_name AS step_name,
		'SELECT aei.[itemNo], aei.[locationNo], ' +
		 CAST(e.custom_column_id AS NVARCHAR) + ' AS customColumnId, ' +
		 IIF(e.select_sql IS NULL, 
		 CASE 
			WHEN e.custom_column_type = 'date' THEN 'CONVERT(NVARCHAR(10), [s].' + QUOTENAME(e.source_column_name) + ',23) AS columnValue'
			WHEN e.custom_column_type = 'boolean' THEN 'IIF([s].' + QUOTENAME(e.source_column_name) + '=1,''true'', ''false'') AS columnValue'
			ELSE 'CAST([s].' + QUOTENAME(e.source_column_name) + ' AS NVARCHAR(255)) AS columnValue'
			END
			,
			e.select_sql + ' AS columnValue'
			)

			+ ' FROM [dk_cus].[AGREssentials_items] aei INNER JOIN ' + 
			QUOTENAME(e.source_object_schema) + '.' + QUOTENAME(e.source_object_name) + ' s ON [aei].[itemNo] = [s].' + QUOTENAME(e.item_no_join_column)
			+ IIF(e.location_no_join_column IS NULL, '', ' AND [aei].[locationNo] = [s].' + QUOTENAME(e.location_no_join_column)) 
			+ ' WHERE [s].' + QUOTENAME(e.source_column_name) + ' IS NOT NULL' + IIF(e.custom_column_type IN ('string'),' AND [s].' + QUOTENAME(e.source_column_name) + ' <> ''''','')
			+ IIF(e.where_sql IS NULL, '', ' AND ' + e.where_sql)
			AS query,
		e.custom_column_id AS custom_column_id

	FROM #customcolumnendpoints e

 
END


