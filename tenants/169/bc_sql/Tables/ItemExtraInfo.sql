CREATE TABLE [bc_sql_cus].[ItemExtraInfo] (
    [No_] NVARCHAR(20) NOT NULL,
    [IsfStatus Code] NVARCHAR(10) NOT NULL,
    [IsfBrand Code] NVARCHAR(10) NOT NULL,
    [IsfColor Group Code] NVARCHAR(10) NOT NULL,
    [Fmr_Extern Description 8] NVARCHAR(250) NOT NULL,
    CONSTRAINT [pk_bc_sql_cus_ItemExtraInfo] PRIMARY KEY (No_)
);
