CREATE PROCEDURE [cus].[get_endpoints]
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
        [database_name] [NVARCHAR](MAX) NULL
    );

    INSERT INTO #endpoints ([id], [step_name], [endpoint], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql], [database_name])
    SELECT [id], [step_name], [endpoint], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql], [database_name]
    FROM [cus].[endpoints];

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
    
    
    DECLARE @max_transaction_history_id NVARCHAR(255)
    --SET @max_transaction_history_id = (SELECT CAST(ISNULL(MAX([TransactionHistoryID]),0) AS NVARCHAR(255)) FROM cus.TransactionHistory) --Equivale à ItemLedgerEntry

    SELECT
        'dbo' AS TableSchema_S
         ,e.[endpoint] AS TableName_S
         ,e.[db_schema] AS TableSchema_T
         ,e.[db_table] AS TableName_T
         ,IIF(e.pre_sql IS NOT NULL,e.pre_sql+CHAR(10),'')+
          'SELECT ' + COALESCE(e.select_sql,(SELECT STRING_AGG(QUOTENAME(c.[column_name]),',')
                                             FROM [dbo].[v_db_object_info] AS c
                                             WHERE  c.[schema_name] = e.[db_schema]
                                               AND c.[object_name] = e.[db_table]))
        + ' FROM '+COALESCE(e.from_sql,'dbo.'+QUOTENAME(IIF(@CompanyName IS NOT NULL AND @CompanyName <> '',@CompanyName+'$','')+e.[endpoint]+IIF(@TablePostfix IS NOT NULL AND @TablePostfix <> '','$'+@TablePostfix,'')))
        + IIF(e.task_type = 7, ' WHERE [TransactionHistoryID] >'+@max_transaction_history_id + IIF(e.where_sql IS NOT NULL,' AND '+e.where_sql,''), IIF(e.where_sql IS NOT NULL,' WHERE '+e.where_sql,'')) AS query,
        IIF(e.task_type <> 7, 'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]),'') AS pre_copy_script,
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
        ) AS column_map,
        e.[database_name]
    FROM #endpoints e
    WHERE e.is_active = 1



END
