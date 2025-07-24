CREATE TABLE [bc_sql_cus].[CustomColumns_Status] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(20) NOT NULL,
    [Status Code] NVARCHAR(50) NOT NULL,
    [Starting Date] DATETIME NOT NULL,
    CONSTRAINT [CustomColumns_Status_PK] PRIMARY KEY (Item No_,Location Code,Starting Date)
);
