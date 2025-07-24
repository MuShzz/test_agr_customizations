CREATE TABLE [bc_sql_cus].[LSCProductGroup] (
    [Item Category Code] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(10) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_bc_sql_cus_LSCProductGroup] PRIMARY KEY (Code,Item Category Code)
);
