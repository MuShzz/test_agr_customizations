CREATE PROCEDURE [cus].[truncate_dimensions_multi]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @dynSQL NVARCHAR(MAX);

    SELECT @dynSQL = STRING_AGG('TRUNCATE TABLE cus.' + QUOTENAME(db_table), ';'+CHAR(10))
    FROM cus.endpoints WHERE task_type = '0' AND is_active = 1
	AND db_table NOT IN ('agr_api_order_lines','agr_api_order_header','agr_setup','agr_log')

    PRINT @dynSQL;

    EXEC sys.sp_executesql @dynSQL;

	SELECT 1;

END;

