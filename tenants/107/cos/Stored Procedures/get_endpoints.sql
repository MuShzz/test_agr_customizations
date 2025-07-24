-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Data merge for COS customers, orchestrated by values in cos(cos_cus.endpoints
--
--  12.03.2023.HMH   Created
-- ===============================================================================
CREATE PROCEDURE [cos_cus].[get_endpoints]
(
@CompanyName NVARCHAR(255) = NULL,
@TablePostfix NVARCHAR(255) = NULL,
@TablePrefix NVARCHAR(255) = NULL
)
AS
BEGIN

	SET NOCOUNT ON



	DECLARE @sql_source_setting NVARCHAR(255) = (SELECT sql_framework FROM [dbo].[tenant_info])                              

	DROP TABLE IF EXISTS #endpoints

	CREATE TABLE #endpoints
	(
		[id] [INT] NOT NULL,
		[step_name] [NVARCHAR](50) NOT NULL,
		[endpoint] [NVARCHAR](100) NULL,
		[endpoint_schema] [NVARCHAR](50) NULL,
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
		[columns_to_merge] [NVARCHAR](MAX) NULL
	);


	-- Populating the #endpoints temporary table with data from [cos].[endpoints], 
	-- and then, if the 'cus.endpoints' table exists, it synchronizes the data in #endpoints with 'cus.endpoints':
	-- 1. Existing rows in #endpoints with matching 'id's are updated with the data from 'cus.endpoints'.
	-- 2. Rows from 'cus.endpoints' that don't have corresponding 'id's in #endpoints are inserted into #endpoints.

INSERT INTO #endpoints ([id], [step_name], [endpoint], [endpoint_schema], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql], [columns_to_merge])
SELECT [id], [step_name], [endpoint], [endpoint_schema], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql], [columns_to_merge]
FROM [cos].[endpoints];


	IF OBJECT_ID('cos.endpoints', 'U') IS NOT NULL
	BEGIN
		-- Update existing rows
		EXEC('
			UPDATE e
			SET 
				e.[step_name] = ce.[step_name],
				e.[endpoint] = ce.[endpoint],
				e.[endpoint_schema] = ce.[endpoint_schema],
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
				e.[post_sql] = ce.[post_sql],
				e.[columns_to_merge] = ce.[columns_to_merge]
			FROM #endpoints e
			INNER JOIN cos.endpoints ce ON e.[id] = ce.[id]
		');

		-- Insert new rows
		EXEC('
			INSERT INTO #endpoints ([id], [step_name], [endpoint], [endpoint_schema], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql], [columns_to_merge])
			SELECT [id], [step_name], [endpoint], [endpoint_schema], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql], [columns_to_merge]
			FROM cos.endpoints ce
			WHERE NOT EXISTS (SELECT 1 FROM #endpoints e WHERE e.[id] = ce.[id])
            and is_active = 1
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
			COALESCE(cc.endpoint_schema, e.endpoint_schema) AS TableSchema_S,
			COALESCE(cc.endpoint, e.endpoint) AS TableName_S,
			COALESCE(cc.db_schema, e.db_schema) AS TableSchema_T,
			COALESCE(cc.db_table, e.db_table) AS TableName_T,
			'SELECT ' + COALESCE(cc.select_sql,cc.columns_to_merge,e.columns_to_merge, '') + 
			' FROM ' + QUOTENAME(COALESCE(cc.endpoint_schema,e.endpoint_schema, '')) + '.' + QUOTENAME(COALESCE(cc.endpoint,e.endpoint, '')) AS query,
			'TRUNCATE TABLE ' + QUOTENAME(COALESCE(cc.db_schema,e.db_schema), '') + '.' + QUOTENAME(COALESCE(cc.db_table,e.db_table), '') AS pre_copy_script,
			(SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
            ,','),
            ']}') AS json_output
			FROM (
					SELECT endpoint,replace(replace(value,'[',''),']','') as column_name
					FROM cos.endpoints CROSS APPLY STRING_SPLIT(columns_to_merge,',')
					WHERE endpoint = e.endpoint
				)  c
			  ) AS column_map
		FROM 
			[cos].[endpoints] e
		LEFT JOIN 
			[cos_cus].[endpoints] cc ON e.step_name = cc.step_name
		WHERE 
			COALESCE(cc.task_type,e.task_type) = 0 AND COALESCE(cc.is_active,e.is_active) =1

		UNION ALL

		SELECT 
			COALESCE(cc.endpoint_schema, e.endpoint_schema) AS TableSchema_S,
			COALESCE(cc.endpoint, e.endpoint) AS TableName_S,
			COALESCE(cc.db_schema, e.db_schema) AS TableSchema_T,
			COALESCE(cc.db_table, e.db_table) AS TableName_T,
			'SELECT ' + COALESCE(cc.select_sql,cc.columns_to_merge,e.columns_to_merge, '') + 
			' FROM ' + QUOTENAME(COALESCE(cc.endpoint_schema,e.endpoint_schema, '')) + '.' + QUOTENAME(COALESCE(cc.endpoint,e.endpoint, '')) +
			CASE 
				WHEN e.step_name = 'AGR_SALES_HISTORY' AND EXISTS (SELECT 1 FROM cos_cus.AGR_SALES_HISTORY) THEN 
					' WHERE [date] > ''' + CAST((SELECT MAX(sah.date) FROM cos_cus.AGR_SALES_HISTORY sah) AS NVARCHAR(MAX)) + ''''
				WHEN e.step_name = 'AGR_STOCK_HISTORY' AND EXISTS (SELECT 1 FROM cos.AGR_STOCK_HISTORY) THEN  
					' WHERE transaction_id > ' + CAST((SELECT MAX(sth.TRANSACTION_ID) FROM cos.AGR_STOCK_HISTORY sth) AS NVARCHAR(MAX))
				WHEN e.step_name = 'AGR_BOM_CONSUMPTION_HISTORY' AND EXISTS (SELECT 1 FROM cos.AGR_BOM_CONSUMPTION_HISTORY) THEN
					' WHERE transaction_id > ' + CAST(ISNULL((SELECT MAX(boh.TRANSACTION_ID) FROM cos.AGR_BOM_CONSUMPTION_HISTORY boh),0) AS NVARCHAR(MAX))
				ELSE 
					'' 
			END AS query,
			'' AS pre_copy_script,
			(SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
            STRING_AGG(CAST(
              CONCAT('{"source":{"name":"' ,c.[column_name], '"},
                   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
            ,','),
            ']}') AS json_output
			FROM (
					SELECT endpoint,replace(replace(value,'[',''),']','') as column_name
					FROM cos.endpoints CROSS APPLY STRING_SPLIT(columns_to_merge,',')
					WHERE endpoint = e.endpoint
				)  c
			  ) AS column_map
		FROM 
			[cos].[endpoints] e
		LEFT JOIN 
			[cos_cus].[endpoints] cc ON e.step_name = cc.step_name
		WHERE 
			COALESCE(cc.task_type,e.task_type) = 7 AND COALESCE(cc.is_active,e.is_active) = 1;



END



