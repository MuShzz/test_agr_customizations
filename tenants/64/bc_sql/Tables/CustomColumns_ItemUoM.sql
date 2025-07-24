CREATE TABLE [bc_sql_cus].[CustomColumns_ItemUoM] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(255) NOT NULL,
    [Cubage] NVARCHAR(255) NOT NULL,
    CONSTRAINT [CustomColumns_ItemUoM_PK] PRIMARY KEY (Code,Item No_)
);
