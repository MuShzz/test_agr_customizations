CREATE PROCEDURE [cus].[create_cus_adi_views]
AS
BEGIN
    SET NOCOUNT ON;

    -- Cursor to loop through all tables in the ADI schema
    DECLARE table_cursor CURSOR FOR
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'ADI';

    DECLARE @TableName NVARCHAR(255);
    DECLARE @SQL NVARCHAR(MAX);

    OPEN table_cursor;

    FETCH NEXT FROM table_cursor INTO @TableName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Generate the view name
        DECLARE @ViewName NVARCHAR(255) = '[cus].[v_' + @TableName + ']';

        -- Generate the column list dynamically
        DECLARE @Columns NVARCHAR(MAX) = '';
        SELECT @Columns = STRING_AGG(
            '   CAST(NULL AS ' + 
            DATA_TYPE +
            CASE 
                -- Handle precision and scale for DECIMAL, NUMERIC, etc.
                WHEN DATA_TYPE IN ('decimal', 'numeric') AND NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS NVARCHAR) + ',' + CAST(NUMERIC_SCALE AS NVARCHAR) + ')'
                -- Handle precision for CHAR, NCHAR, VARCHAR, NVARCHAR, etc.
                WHEN DATA_TYPE IN ('char', 'nchar', 'varchar', 'nvarchar') AND CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + 
                    CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN 'MAX' ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR) END + ')'
                -- Handle precision for other data types as needed
                ELSE ''
            END +
            ') AS [' + COLUMN_NAME + ']', ', 
            '
        )
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = 'ADI' AND TABLE_NAME = @TableName;

        -- Check if columns exist
        IF @Columns IS NOT NULL AND @Columns <> ''
        BEGIN
            -- Generate the CREATE OR ALTER VIEW statement
            SET @SQL = '
            CREATE OR ALTER VIEW ' + @ViewName + '
             AS
            SELECT 
            ' + @Columns + '
            WHERE 1 = 0;';

            -- Debugging: Print the SQL for the current view
            PRINT 'Creating view for table: ' + @TableName;
            PRINT @SQL;

            -- Execute the generated SQL for the current view
            BEGIN TRY
                EXEC sp_executesql @SQL;
            END TRY
            BEGIN CATCH
                PRINT 'Error creating view for table ' + @TableName + ': ' + ERROR_MESSAGE();
            END CATCH;
        END
        ELSE
        BEGIN
            PRINT 'Skipping table ' + @TableName + ' because it has no columns.';
        END;

        FETCH NEXT FROM table_cursor INTO @TableName;
    END;

    CLOSE table_cursor;
    DEALLOCATE table_cursor;

    PRINT 'All views have been created.';
END;
