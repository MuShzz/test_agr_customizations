CREATE TABLE [bc_sql_cus].[ItemVariantExtraInfo] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(10) NOT NULL,
    [IsfStatus Code] NVARCHAR(10) NOT NULL,
    [IsfColor Code] NVARCHAR(10) NOT NULL,
    CONSTRAINT [pk_bc_sql_cus_ItemVariantExtraInfo] PRIMARY KEY (Code,Item No_)
);
