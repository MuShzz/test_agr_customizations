
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Get erp_raw view list
--
-- 2023.07.04.TO   Created
-- ===============================================================================
CREATE PROCEDURE [cus].[get_views_multi]
AS
BEGIN
	SET NOCOUNT ON

    DECLARE @max_sale_date NVARCHAR(10)
    SET @max_sale_date = ISNULL((SELECT MAX([DATE]) FROM [erp_raw].[sale_history]),'1900-01-01')

    DECLARE @max_stock_date NVARCHAR(10)
    SET @max_stock_date = ISNULL((SELECT MAX([DATE]) FROM [erp_raw].[stock_history]),'1900-01-01')

    DECLARE @max_customer_sale_date NVARCHAR(10)
    SET @max_customer_sale_date = ISNULL((SELECT MAX([DATE]) FROM [erp_raw].[customer_sale_transaction]),'1900-01-01')


  SELECT 
        'cus' AS TableSchema_S
      ,e.[view_name] AS TableName_S
      ,e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'SELECT ' + (SELECT STRING_AGG(QUOTENAME(c.[column_name]),',') 
                        FROM [dbo].[v_db_object_info] AS c
                               WHERE  c.[schema_name] = e.[db_schema]
                                  AND c.[object_name] = e.[db_table])
	   + ' 
  FROM (
		SELECT ' + (SELECT STRING_AGG('t1.'+QUOTENAME(c.[column_name]),',') 
                        FROM [dbo].[v_db_object_info] AS c
                               WHERE  c.[schema_name] = e.[db_schema]
                                  AND c.[object_name] = e.[db_table]) 	
	   + ', RANK() OVER (PARTITION BY '+(SELECT STRING_AGG('t1.'+QUOTENAME(COLUMN_NAME),',') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
                                                                                                               FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                                                                                                              WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1
                                                                                                                AND TABLE_NAME = e.[db_table] AND TABLE_SCHEMA = e.[db_schema])+' ORDER BY prio.[priority] DESC) AS [Rank] '
       + 
'
		  FROM [cus].'+QUOTENAME(e.[view_name])+' t1
     LEFT JOIN [cus].[companies_record_exceptions] cre ON cre.[entity_name] = '''+e.[db_table]+''' AND '+(SELECT STRING_AGG('t1.'+QUOTENAME(COLUMN_NAME)+'=cre.'+QUOTENAME('KEY_VALUE_'+CAST(ORDINAL_POSITION AS NVARCHAR(3))),' AND ') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
                                                                                                               FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                                                                                                              WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1
                                                                                                                AND TABLE_NAME = e.[db_table] AND TABLE_SCHEMA = e.[db_schema])+'
    INNER JOIN [cus].[companies_entity_priorities] prio ON prio.[entity_name] = '''+[db_table]+''' AND prio.company = t1.company
         WHERE t1.[COMPANY] IS NULL
            OR t1.company = cre.company
            OR (t1.[COMPANY] = prio.[company] AND cre.[company] IS NULL)
       ) t3 WHERE t3.[RANK] = 1'
   AS query,
       'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]) AS pre_copy_script,
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
  FROM [erp_raw].[views_to_tables] e
  WHERE task_type = 0 AND is_active = 1 AND e.[db_table] <> 'stock_level'
    UNION ALL
    SELECT 
            'cus' AS TableSchema_S
          ,e.[view_name] AS TableName_S
          ,e.[db_schema] AS TableSchema_T
          ,e.[db_table] AS TableName_T
          ,'SELECT ' + (SELECT STRING_AGG(QUOTENAME(c.[column_name]),',')
                            FROM [dbo].[v_db_object_info] AS c
                                   WHERE  c.[schema_name] = e.[db_schema]
                                      AND c.[object_name] = e.[db_table]
                                      )
           + ' FROM cus.'+QUOTENAME(e.[view_name])
           AS query,
           --'DELETE FROM erp_raw.'+QUOTENAME(e.[db_table])
           --+ ' WHERE [DATE] = '''+CAST(@max_sale_date AS NVARCHAR(MAX))+''''  AS pre_copy_script
           'TRUNCATE TABLE '+QUOTENAME(e.[db_schema])+'.'+QUOTENAME(e.[db_table]) AS pre_copy_script,
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
      FROM [erp_raw].[views_to_tables] e
      WHERE task_type = 0 AND is_active = 1 AND e.[db_table] = 'stock_level'
    UNION ALL 
  --SELECT @max_sale_date = 'DECLARE @max_entry_no DATE = ''' + ISNULL((SELECT MAX([DATEPHYSICAL]) FROM [dbo].[INVENTTRANS]),'1900-01-01')+''''
  -- Transactional views
  SELECT 
        'cus' AS TableSchema_S
      ,e.[view_name] AS TableName_S
      ,e.[db_schema] AS TableSchema_T
      ,e.[db_table] AS TableName_T
      ,'SELECT ' + (SELECT STRING_AGG(CASE WHEN c.[column_name] = 'TRANSACTION_ID' THEN 'CONCAT(CONVERT(VARCHAR, CAST([date] AS DATE), 112),100000000+ROW_NUMBER() OVER(order BY [date])) AS [transaction_id]'
                                                     ELSE QUOTENAME(c.[column_name]) END,',')
                        FROM [dbo].[v_db_object_info] AS c
                               WHERE  c.[schema_name] = e.[db_schema]
                                  AND c.[object_name] = e.[db_table]
                                  )
       + ' FROM cus.'+QUOTENAME(e.[view_name])
       + ' WHERE [Date] > '''+CASE 
                                        WHEN step_name = 'sale_history' THEN @max_sale_date
                                        WHEN step_name = 'stock_history' THEN @max_stock_date    
                                        WHEN step_name = 'customer_sale_transaction' THEN @max_customer_sale_date
                                    END
       +''''
       + ' AND CAST([Date] AS DATE) < CAST(GETDATE() AS DATE)'
       AS query,
       --'DELETE FROM erp_raw.'+QUOTENAME(e.[db_table])
       --+ ' WHERE [DATE] = '''+CAST(@max_sale_date AS NVARCHAR(MAX))+''''  AS pre_copy_script
       '' AS pre_copy_script,
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
  FROM [erp_raw].[views_to_tables] e
  WHERE task_type = 7 AND is_active = 1

END


