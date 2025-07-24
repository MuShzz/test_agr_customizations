CREATE TABLE [bc_sql_cus].[Item_LSC] (
    [No_] NVARCHAR(20) NOT NULL,
    [LSC Retail Product Code] NVARCHAR(20) NOT NULL,
    [LSC Season Code] NVARCHAR(10) NOT NULL,
    [LSC Item Family Code] NVARCHAR(20) NOT NULL,
    [company] NVARCHAR(4) NULL,
    CONSTRAINT [pk_cus_Item_LSC] PRIMARY KEY (No_)
);
