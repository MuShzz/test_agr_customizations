CREATE PROCEDURE [bc_sql_cus].[get_endpoints](
    @CompanyName NVARCHAR(255) = NULL,
    @TablePostfix NVARCHAR(255) = NULL,
    @TablePrefix NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @max_sql NVARCHAR(MAX), @dynamic_sql NVARCHAR(MAX);

    --IF OBJECT_ID('bc_sql_cus.get_endpoints', 'P') IS NOT NULL
    --    BEGIN
    --        SET @dynamic_sql = 'EXEC bc_sql_cus.get_endpoints @CompanyName, @TablePostfix, @TablePrefix';
    --        EXEC sp_executesql @dynamic_sql,
    --             N'@CompanyName NVARCHAR(255), @TablePostfix NVARCHAR(255), @TablePrefix NVARCHAR(255)', @CompanyName,
    --             @TablePostfix, @TablePrefix;
    --        RETURN;
    --    END;

    DROP TABLE IF EXISTS #endpoints

    CREATE TABLE #endpoints
    (
        [id]           [INT]           NOT NULL,
        [step_name]    [NVARCHAR](50)  NOT NULL,
        [endpoint]     [NVARCHAR](100) NULL,
		[TablePostfix] [NVARCHAR](255) NULL,
        [task_type]    [INT]           NOT NULL,
        [db_schema]    [NVARCHAR](50)  NULL,
        [db_table]     [NVARCHAR](500) NOT NULL,
        [priority]     [INT]           NOT NULL,
        [is_active]    [BIT]           NOT NULL,
        [pre_sql_exec] [NVARCHAR](MAX) NULL,
        [pre_sql]      [NVARCHAR](MAX) NULL,
        [select_sql]   [NVARCHAR](MAX) NULL,
        [from_sql]     [NVARCHAR](MAX) NULL,
        [where_sql]    [NVARCHAR](MAX) NULL,
        [post_sql]     [NVARCHAR](MAX) NULL
    );

    INSERT INTO #endpoints ([id], [step_name], [endpoint], [TablePostfix], [task_type], [db_schema], [db_table], [priority],
                            [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql])
    SELECT [id],
           [step_name],
           [endpoint],
		   NULL AS [TablePostfix],
           [task_type],
           [db_schema],
           [db_table],
           [priority],
           [is_active],
           [pre_sql_exec],
           [pre_sql],
           [select_sql],
           [from_sql],
           [where_sql],
           [post_sql]
    FROM [bc_sql].[endpoints];


    IF OBJECT_ID('bc_sql_cus.endpoints', 'U') IS NOT NULL
        BEGIN
            -- Update existing rows
            EXEC ('
			UPDATE e
			SET
				e.[step_name] = ce.[step_name],
				e.[endpoint] = ce.[endpoint],
				e.[TablePostfix] = ce.[TablePostfix],
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
			INNER JOIN bc_sql_cus.endpoints ce ON e.[id] = ce.[id]
		');

            -- Insert new rows
            EXEC ('
			INSERT INTO #endpoints ([id], [step_name], [endpoint], [TablePostfix], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql])
			SELECT [id], [step_name], [endpoint], [TablePostfix], [task_type], [db_schema], [db_table], [priority], [is_active], [pre_sql_exec], [pre_sql], [select_sql], [from_sql], [where_sql], [post_sql]
			FROM bc_sql_cus.endpoints ce
			WHERE NOT EXISTS (SELECT 1 FROM #endpoints e WHERE e.[id] = ce.[id])
		');
        END;
		
    CREATE TABLE #max_entries
    (
        company      char(3),
        max_entry_no NVARCHAR(255)
    );

    SET @max_sql = '
        INSERT INTO #max_entries (company, max_entry_no)
        SELECT ISNULL(cp.company,''''), CAST(ISNULL(MAX(ile.[Entry No_]), 0) AS NVARCHAR(255))
        FROM ' + IIF(OBJECT_ID('[bc_sql_cus].[ItemLedgerEntry]', 'U') IS NOT NULL,
                     '[bc_sql_cus].[ItemLedgerEntry] ile',
                     '[bc_sql].[ItemLedgerEntry] ile') + '
        LEFT JOIN bc_sql_cus.companies cp ON ile.COMPANY = cp.company and cp.is_active = 1
        GROUP BY ISNULL(cp.company,'''')';

    EXEC sp_executesql @max_sql;


    SELECT 'dbo'                                                         AS TableSchema_S
         , e.[endpoint]                                                  AS TableName_S
         , e.[db_schema]                                                 AS TableSchema_T
         , e.[db_table]                                                  AS TableName_T
         , IIF(e.pre_sql IS NOT NULL, e.pre_sql + CHAR(10), '') +
           'SELECT ' + COALESCE(e.select_sql, (SELECT STRING_AGG(QUOTENAME(c.[column_name]), ',')
                                               FROM [dbo].[v_db_object_info] AS c
                                               WHERE c.[schema_name] = e.[db_schema]
                                                 AND c.[object_name] = e.[db_table]
                                                 AND c.[column_name] <> 'company'))
        + ' FROM ' +
           COALESCE(e.from_sql, 'dbo.' + QUOTENAME(ISNULL(cp.table_pre_fix, @CompanyName) + '$' + e.[endpoint] +
                                                   CASE 
														WHEN e.[TablePostfix] IS NOT NULL
															THEN '$' + e.[TablePostfix]
														ELSE '$' + ISNULL(cp.table_post_fix, @TablePostfix)
													END
												))
        + IIF(e.task_type = 7,
              ' WHERE [Entry No_] > ' + ISNULL(me.max_entry_no, 0)
              --+ IIF(e.where_sql IS NOT NULL, ' AND ' + e.where_sql, '')
               ,
              IIF(e.where_sql IS NOT NULL, ' WHERE ' + e.where_sql, '')) AS query
         , IIF(e.task_type <> 7, 'TRUNCATE TABLE ' + QUOTENAME(e.[db_schema]) + '.' + QUOTENAME(e.[db_table]),
               '')                                                       AS pre_copy_script
         , IIF(e.post_sql IS NOT NULL, e.post_sql, '')                   AS post_copy_script
         , (SELECT CONCAT('{"type": "TabularTranslator", "mappings": ', '[',
                          STRING_AGG(CAST(
                                             CONCAT('{"source":{"name":"', c.[column_name], '"},
                   "sink":{"name":"', c.[column_name], '"}}') AS NVARCHAR(MAX))
                              , ','),
                          ']}') AS json_output
            FROM [dbo].[v_db_object_info] AS c
            WHERE c.[schema_name] = e.[db_schema]
              AND c.[object_name] = e.[db_table])                        AS column_map
         ,

         -- returning all columns in the companies table, so in case we customize the companies table,
         -- we don't need to customize the procedure.

        cp.*

    FROM #endpoints e
             left join bc_sql_cus.companies cp on cp.is_active = 1
             left join #max_entries me on me.company = ISNULL(cp.company,'')
    WHERE e.is_active = 1

END

