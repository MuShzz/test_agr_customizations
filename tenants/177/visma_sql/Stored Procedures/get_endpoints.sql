CREATE PROCEDURE [visma_sql_cus].[get_endpoints]
(
@CompanyName NVARCHAR(255) = NULL,
@TablePostfix NVARCHAR(255) = NULL,
@TablePrefix NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	;WITH 
	max_jno 
	AS
	(
	SELECT ISNULL(MAX([JNo]),0) AS max_jno  FROM [visma_sql].[ProdTr]
	),
	max_trno
	AS
	(
	SELECT ISNULL(MAX([TrNo]),0) AS max_trno
	FROM [visma_sql].[ProdTr] p
	INNER JOIN max_jno m ON m.max_jno = p.[JNo]
	)
	SELECT 
		'dbo' AS TableSchema_S
		,[endpoint] AS TableName_S
		,[db_schema] AS TableSchema_T
		,[db_table] AS TableName_T,
		'SELECT ' + (SELECT STRING_AGG(QUOTENAME(c.[column_name]),',') 
					FROM [dbo].[v_db_object_info] as c
							where  c.[schema_name] = e.[db_schema]
								AND c.[object_name] = e.[db_table])
		+ ' FROM dbo.'+QUOTENAME(e.[db_table]) AS query,
		'' AS [column_map],
		IIF(e.task_type <> 7, 'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]),'') AS pre_copy_script,
		'' AS post_copy_script
	FROM [visma_sql].[endpoints] e
	WHERE task_type = 0 and is_active = 1
	UNION ALL
	SELECT 
		'dbo' AS TableSchema_S
		,[endpoint] AS TableName_S
		,[db_schema] AS TableSchema_T
		,[db_table] AS TableName_T
		,'SELECT ' + (SELECT STRING_AGG(QUOTENAME(c.[column_name]),',') 
					FROM [dbo].[v_db_object_info] AS c
							WHERE  c.[schema_name] = e.[db_schema]
								AND c.[object_name] = e.[db_table])
		+ ' FROM dbo.'+QUOTENAME(e.[db_table]),
		'' AS [column_map],
		'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]) AS pre_copy_script,
		'' AS post_copy_script
	FROM [visma_sql].[endpoints] e
	CROSS JOIN max_jno m
	CROSS JOIN max_trno mt
	WHERE e.step_name = 'product transactions'

	UNION ALL

	SELECT 
		'dbo' AS TableSchema_S,
		e.[endpoint] AS TableName_S,
		e.[db_schema] AS TableSchema_T,
		e.[db_table] AS TableName_T,
		'SELECT ' + (SELECT STRING_AGG(QUOTENAME(c.[column_name]), ',') 
						FROM [dbo].[v_db_object_info] AS c
						WHERE c.[schema_name] = e.[db_schema]
						AND c.[object_name] = e.[db_table]) 
		+ ' FROM dbo.' + QUOTENAME(e.[db_table]),
		'' AS [column_map],
		'TRUNCATE TABLE ' + QUOTENAME(e.[db_schema]) + '.' + QUOTENAME(e.[db_table]) AS pre_copy_script,
		'' AS post_copy_script
	FROM [visma_sql_cus].endpoints e
END

