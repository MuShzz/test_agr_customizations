CREATE PROCEDURE cus.populate_normalization_tables
(
    @db_table NVARCHAR(100) = NULL,
    @array_table NVARCHAR(100) = NULL,
    @db_table_destiny NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @db_table_destiny IS NOT NULL AND @array_table IS NOT NULL
    BEGIN    

		DECLARE @truncate NVARCHAR(255);
		SET @truncate = 'TRUNCATE TABLE [cus].' + QUOTENAME(@db_table_destiny);
		EXEC sp_executesql @truncate;


        DECLARE @ArrayColumns NVARCHAR(MAX);
        DECLARE @Columns NVARCHAR(MAX);
        DECLARE @fromClause NVARCHAR(MAX);
        DECLARE @sql NVARCHAR(MAX);

        SELECT @ArrayColumns = STRING_AGG(
            'JSON_VALUE(d.value, ''$.' + CASE WHEN column_name LIKE '$%' THEN CASE 
																				WHEN column_name LIKE '$%' 
																				THEN STUFF(column_name, 1, 1, '') 
																				ELSE column_name 
																			END 
										   END + ''') AS [' + column_name + ']', 
            ', '
        )
        FROM dbo.v_db_object_info
        WHERE object_name = @db_table_destiny;

        SELECT @Columns = STRING_AGG(
            't.[' +  column_name  + '] AS [' + column_name + ']', 
            ', '
        )
        FROM dbo.v_db_object_info
        WHERE object_name = @db_table_destiny AND column_name NOT LIKE '$%'
      

        SET @fromClause = 'FROM cus.' + @db_table + ' t CROSS APPLY OPENJSON(CONVERT(NVARCHAR(MAX), t.[' + @array_table + '])) d';
        
       
        SET @sql = 'INSERT INTO cus.' + @db_table_destiny + ' SELECT ' + @Columns + ', ' + @ArrayColumns + ' ' + @fromClause + ';';
        
     
        EXEC sp_executesql @sql;
    END
END;

