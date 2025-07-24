CREATE TABLE [bc_sql_cus].[Purchasing] (
    [Code] NVARCHAR(10) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [company] NVARCHAR(4) NULL,
    CONSTRAINT [pk_cus_Purchasing] PRIMARY KEY (Code)
);
