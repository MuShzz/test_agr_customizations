CREATE TABLE [bc_sql_cus].[CC_Brand] (
    [Code] NVARCHAR(10) NOT NULL,
    [Type] INT NOT NULL,
    [Description] NVARCHAR(30) NOT NULL,
    CONSTRAINT [pk_bc_sql_cus_CC_Brand] PRIMARY KEY (Code,Type)
);
