CREATE TABLE [bc_sql_cus].[StockkeepingUnitExt] (
    [Location Code] NVARCHAR(10) NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    [Variant Code] NVARCHAR(10) NOT NULL,
    [Product In Range$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] TINYINT NOT NULL,
    CONSTRAINT [PK_bc_sql_cus_StockkeepingUnitExt] PRIMARY KEY (Item No_,Location Code,Variant Code)
);
