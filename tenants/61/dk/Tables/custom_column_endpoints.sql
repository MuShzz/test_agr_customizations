CREATE TABLE [dk_cus].[custom_column_endpoints] (
    [id] INT NOT NULL,
    [step_name] NVARCHAR(50) NOT NULL,
    [custom_column_id] INT NOT NULL,
    [custom_column_type] NVARCHAR(50) NOT NULL,
    [source_object_schema] NVARCHAR(255) NULL,
    [source_object_name] NVARCHAR(255) NULL,
    [source_column_name] NVARCHAR(255) NULL,
    [item_no_join_column] NVARCHAR(255) NULL,
    [location_no_join_column] NVARCHAR(255) NULL,
    [is_active] BIT NOT NULL,
    [pre_sql_exec] NVARCHAR(MAX) NULL,
    [pre_sql] NVARCHAR(MAX) NULL,
    [select_sql] NVARCHAR(MAX) NULL,
    [from_sql] NVARCHAR(MAX) NULL,
    [where_sql] NVARCHAR(MAX) NULL,
    [post_sql] NVARCHAR(MAX) NULL,
    CONSTRAINT [PK_cus_endpoints] PRIMARY KEY (id)
);
