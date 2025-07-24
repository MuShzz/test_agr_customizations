  CREATE PROCEDURE cus.CreateTableFromStructureMeta
    @TargetTableName NVARCHAR(128)
AS
BEGIN
       SET NOCOUNT ON;

    PRINT 'Starting table creation for: ' + @TargetTableName;

    DECLARE @SQL NVARCHAR(MAX) = '';
    DECLARE @Line NVARCHAR(MAX);

    -- Temp table to hold ordered column definitions
    DECLARE @Columns TABLE (Line NVARCHAR(MAX), Ord INT IDENTITY(1,1));

    -- Build column definitions line by line
    INSERT INTO @Columns (Line)
    SELECT
        '    ' + QUOTENAME(COLUMN_NAME) + ' ' +
        CASE 
            WHEN DATA_TYPE IN ('nvarchar', 'varchar', 'char', 'nchar') THEN 
                DATA_TYPE + 
                CASE 
                    WHEN CHARACTER_MAXIMUM_LENGTH IS NULL THEN ''
                    WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN '(MAX)'
                    ELSE '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR) + ')'
                END
            WHEN DATA_TYPE IN ('decimal', 'numeric') THEN 
                DATA_TYPE + '(18, 2)' -- default precision/scale
            ELSE DATA_TYPE
        END + ' ' +
        CASE WHEN IS_NULLABLE = 1 THEN 'NULL' ELSE 'NOT NULL' END
    FROM cus.columns  -- ⬅ Replace with your actual metadata table
    WHERE TABLE_NAME = @TargetTableName;

    -- Start building the SQL
    SET @SQL = 'CREATE TABLE cus.' + QUOTENAME(@TargetTableName) + ' (' + CHAR(13);

    DECLARE @Index INT = 1;
    DECLARE @Total INT;
    SELECT @Total = COUNT(*) FROM @Columns;

    WHILE @Index <= @Total
    BEGIN
        SELECT @Line = Line FROM @Columns WHERE Ord = @Index;
        SET @SQL += @Line;
        IF @Index < @Total SET @SQL += ',' + CHAR(13);
        SET @Index += 1;
    END

    SET @SQL += CHAR(13) + ');';

    PRINT 'Final CREATE TABLE script:';
    PRINT @SQL;

    -- Execute the final script
    EXEC sp_executesql @SQL;

    PRINT 'Table created successfully!';

END;

