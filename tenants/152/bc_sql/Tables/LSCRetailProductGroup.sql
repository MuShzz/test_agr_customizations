CREATE TABLE [bc_sql_cus].[LSCRetailProductGroup] (
    [Code] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [company] NVARCHAR(4) NULL,
    CONSTRAINT [pk_cus_LSCRetailProductGroup] PRIMARY KEY (Code)
);
