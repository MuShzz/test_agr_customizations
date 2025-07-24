CREATE TABLE [bc_sql_cus].[companies] (
    [company] CHAR(3) NULL,
    [company_name] NVARCHAR(255) NULL,
    [table_post_fix] NVARCHAR(255) NULL,
    [table_pre_fix] NVARCHAR(255) NULL,
    [priority] INT NULL,
    [is_active] BIT NULL,
    [order_transfer_url] NVARCHAR(1000) NULL
);
