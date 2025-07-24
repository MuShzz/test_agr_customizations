CREATE TABLE [bc_sql_cus].[ItemExtraInfo] (
    [No_] NVARCHAR(20) NOT NULL,
    [Purch_ Unit of Measure] NVARCHAR(10) NOT NULL,
    [Purchasing Code] NVARCHAR(10) NOT NULL,
    [company] NVARCHAR(4) NULL,
    CONSTRAINT [pk_cus_ItemExtraInfo] PRIMARY KEY (No_)
);
