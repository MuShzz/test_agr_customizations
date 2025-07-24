
-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Finding columns in common to merge date from COS source
--
--  12.03.2023.HMH   Created
-- ===============================================================================
CREATE PROCEDURE [cos_cus].[populate_available_columns]
(
@ColumnsToMerge NVARCHAR(MAX) = NULL,
@SourceTableName NVARCHAR(255) = NULL,
@SourceTableSchema NVARCHAR(255) = NULL,
@TargetTableName NVARCHAR(255) = NULL,
@TargetTableSchema NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @source_columns NVARCHAR(MAX) = @ColumnsToMerge
	DECLARE @target_columns NVARCHAR(MAX) = (SELECT STRING_AGG(COLUMN_NAME, ',') AS concatenated_columns
											 FROM INFORMATION_SCHEMA.COLUMNS
											 WHERE TABLE_NAME = @TargetTableName
											 AND TABLE_SCHEMA = @TargetTableSchema)

	DECLARE @sql_source_setting NVARCHAR(255) = (SELECT sql_framework FROM [dbo].[tenant_info])


	-- Split strings into individual words
	DECLARE @source_words TABLE (word NVARCHAR(MAX))
	DECLARE @target_words TABLE (word NVARCHAR(MAX))

	IF @sql_source_setting = 'MYSQL'
	BEGIN
		INSERT INTO @source_words
		SELECT '`'+value+'`' FROM STRING_SPLIT(@source_columns, ',')

		INSERT INTO @target_words
		SELECT '`'+value+'`' FROM STRING_SPLIT(@target_columns, ',')
	END

	ELSE IF @sql_source_setting = 'TSQL'
	BEGIN
		INSERT INTO @source_words
		SELECT value FROM STRING_SPLIT(@source_columns, ',')

		INSERT INTO @target_words
		SELECT value FROM STRING_SPLIT(@target_columns, ',')
	END

	
	-- Find common words
	DECLARE @common_columns NVARCHAR(MAX) = (SELECT CASE WHEN @sql_source_setting = 'TSQL' 
											 THEN STRING_AGG(QUOTENAME(ws.word), ',') 
											 ELSE STRING_AGG(ws.word, ',') END AS concatenated_columns
												FROM @source_words ws
												INNER JOIN @target_words wt ON ws.word = wt.word)


	IF OBJECT_ID('cos_cus.endpoints', 'U') IS NOT NULL
	BEGIN

		UPDATE e
		SET e.columns_to_merge = @common_columns
		FROM cos_cus.endpoints e
		WHERE e.endpoint = @SourceTableName
			  AND e.endpoint_schema = @SourceTableSchema;

		UPDATE e
		SET e.is_active = 0
		FROM cos_cus.endpoints e
		WHERE e.endpoint = @SourceTableName
			  AND e.endpoint_schema = @SourceTableSchema
			  AND @common_columns IS NULL;
	END;
	ELSE
	BEGIN
		UPDATE e
		SET e.columns_to_merge = @common_columns
		FROM cos.endpoints e
		WHERE e.endpoint = @SourceTableName
			  AND e.endpoint_schema = @SourceTableSchema;

		UPDATE e
		SET e.is_active = 0
		FROM cos.endpoints e
		WHERE e.endpoint = @SourceTableName
			  AND e.endpoint_schema = @SourceTableSchema
			  AND @common_columns IS NULL;
	END;
END

