CREATE PROCEDURE [cus].[get_endpoints]
(
    @CompanyName NVARCHAR(255) = NULL,
    @TablePrefix NVARCHAR(255) = NULL,
    @TablePostfix NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @StartDate DATE = '2021-01-01';
    DECLARE @LastDate DATE = NULL;
    DECLARE @EndDate DATE = GETDATE();
    DECLARE @RangeEndDate DATE = NULL;

    SET @LastDate =  (SELECT DATEADD(day, 1, ISNULL((SELECT TOP 1 CAST(DATE AS DATE) FROM cus.stock_history ORDER BY DATE DESC),'2021-01-01' )))
    --SET @RangeEndDate = IIF(DATEADD(DAY, 14, @LastDate) > @EndDate, @EndDate, DATEADD(DAY, 14, @LastDate))
    SET @RangeEndDate = IIF(DATEADD(month, 2, @LastDate) > @EndDate, @EndDate, DATEADD(month, 2, @LastDate))

    
    SELECT e.[endpoint] AS [endpoint_id]
         ,iif(e.task_type <> 7,
              e.[endpoint_body],
                case when [db_table] = 'Stock_History' then CONCAT('[{ "name": "fromdate", "value": "', CONVERT(NVARCHAR(10),@LastDate, 23),'"},{ "name": "todate", "value": "',
                                                                   CONVERT(NVARCHAR(10), @RangeEndDate, 23),'" }]')
                else e.[endpoint_body] end
          ) AS [body]
         ,e.[db_schema] AS TableSchema_T
         ,e.[db_table] AS TableName_T
         ,IIF(e.pre_sql IS NOT NULL,e.pre_sql+CHAR(10),'')+
          NULL AS query,
        IIF(e.task_type <> 7,
            'IF OBJECT_ID('''+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])+''', ''U'') IS NOT NULL BEGIN TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])+' END',
            'delete from '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table])+' WHERE '+
            CASE WHEN [db_table] = 'Sales_History' THEN 'CAST([DATE] AS DATE)'
                 WHEN [db_table] = 'Stock_History' THEN 'CAST([DATE] AS DATE)'
                 ELSE '' END+' >= CAST(GETDATE() - CAST(10 AS int) AS DATE)') AS pre_copy_script,
        IIF(e.post_sql IS NOT NULL,e.post_sql,'') AS post_copy_script,
        (SELECT  CONCAT(  '{"type": "TabularTranslator", "mappings": ', '[',
                          STRING_AGG(CAST(
                                             CONCAT('{"source":{"name":"' ,c.[column_name], '"},
	   					   "sink":{"name":"',   c.[column_name], '"}}') AS NVARCHAR(MAX))
                              ,','),
                          ']}') AS json_output
         FROM [dbo].[v_db_object_info] AS c
         WHERE c.[schema_name] = e.[db_schema]
           AND c.[object_name] = e.[db_table]) AS column_map
    FROM cus.endpoints e
    WHERE e.is_active = 1

END
