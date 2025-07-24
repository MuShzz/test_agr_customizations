
 CREATE PROCEDURE [cus].[get_max_transaction]
    @TableName sysname  
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM   sys.columns   c
        JOIN   sys.objects   o ON o.object_id = c.object_id
        WHERE  o.schema_id = SCHEMA_ID('cus')
          AND  o.name       = @TableName
          AND  c.name       = 'TRANSACTION_ID'
    )
    BEGIN
        DECLARE @sql NVARCHAR(MAX) =
            N'SELECT MAX(TRANSACTION_ID)-1 AS MaxTransactionID
              FROM cus.' + QUOTENAME(@TableName) + ';';

        EXEC sp_executesql @sql;
    END
    ELSE
    BEGIN
        SELECT CAST(NULL AS BIGINT) AS MaxTransactionID;
    END
END;

