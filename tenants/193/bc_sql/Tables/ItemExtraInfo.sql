CREATE TABLE [bc_sql_cus].[ItemExtraInfo] (
    [No_] NVARCHAR(20) NOT NULL,
    [Routing No_] NVARCHAR(20) NOT NULL,
    [company] CHAR(3) NOT NULL DEFAULT (''),
    CONSTRAINT [pk_bc_sql_cus_ItemExtraInfo] PRIMARY KEY (company,No_)
);
