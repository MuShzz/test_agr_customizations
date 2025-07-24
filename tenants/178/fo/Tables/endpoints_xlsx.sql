CREATE TABLE [fo_cus].[endpoints_xlsx] (
    [id] INT NOT NULL,
    [step_name] NVARCHAR(50) NOT NULL,
    [endpoint] NVARCHAR(100) NULL,
    [endpoint_schema] NVARCHAR(50) NULL,
    [task_type] INT NOT NULL,
    [db_schema] NVARCHAR(50) NULL,
    [db_table] NVARCHAR(255) NOT NULL,
    [priority] INT NOT NULL,
    [is_active] BIT NOT NULL,
    [pre_sql_exec] NVARCHAR(MAX) NULL,
    [pre_sql] NVARCHAR(MAX) NULL,
    [select_sql] NVARCHAR(MAX) NULL,
    [from_sql] NVARCHAR(MAX) NULL,
    [where_sql] NVARCHAR(MAX) NULL,
    [post_sql] NVARCHAR(MAX) NULL,
    [columns_to_merge] NVARCHAR(MAX) NULL,
    CONSTRAINT [PK_fo_cus_endpoints_xlsx] PRIMARY KEY (id)
);
