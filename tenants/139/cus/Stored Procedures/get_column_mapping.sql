

-- =============================================================================== 
-- Author:      Ágúst Örn Grétarsson
-- Create date: 28.02.2020 
-- Description: Get column mapping
-- =============================================================================== 
create PROCEDURE [cus].[get_column_mapping]
(
    @db_schema NVARCHAR(255), 
    @db_table NVARCHAR(1000)
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mapping NVARCHAR(MAX)
    SET @mapping = ( 
        SELECT STUFF((
            SELECT CASE WHEN [column_name] <> 'Company' 
                     THEN ' {"source":{"path":"[''' + [column_name] + ''']"},"sink":{"name":"'+ [column_name] + '","type":"' + [data_type] + '"}},' 
                     ELSE ' {"source":{"path":"$[''' + [column_name] + ''']"},"sink":{"name":"'+ [column_name] + '","type":"' + [data_type] + '"}},' 
                 END
            FROM dbo.v_db_object_info
            WHERE  schema_name = @db_schema AND object_name = @db_table
            FOR XML PATH(''), TYPE).value('.', 'varchar(MAX)'),1,1,''
        )
    ) 
    SET @mapping = '{"type":"TabularTranslator","mappings":[' + LEFT(@mapping, LEN(@mapping) - 1) + '],"collectionReference":"$[''value'']","mapComplexValuesToString":true}' 
    SELECT @mapping AS json_output
END

