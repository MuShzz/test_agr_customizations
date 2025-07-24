CREATE TABLE [bc_sql_cus].[LSCBuyerGroup] (
    [Code] NVARCHAR(10) NOT NULL,
    [Description] NVARCHAR(30) NOT NULL,
    [company] NVARCHAR(4) NULL,
    CONSTRAINT [pk_cus_LSCBuyerGroup] PRIMARY KEY (Code)
);
