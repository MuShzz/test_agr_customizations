CREATE TABLE [bc_sql_cus].[RoutingLine] (
    [Operation No_] NVARCHAR(10) NOT NULL,
    [Routing No_] NVARCHAR(20) NOT NULL,
    [Version Code] NVARCHAR(20) NOT NULL,
    [Setup Time Unit of Meas_ Code] NVARCHAR(10) NOT NULL,
    [Run Time Unit of Meas_ Code] NVARCHAR(10) NOT NULL,
    [Wait Time Unit of Meas_ Code] NVARCHAR(10) NOT NULL,
    [Move Time Unit of Meas_ Code] NVARCHAR(10) NOT NULL,
    [Setup Time] DECIMAL(38,20) NOT NULL,
    [Run Time ] DECIMAL(38,20) NOT NULL,
    [Wait Time] DECIMAL(38,20) NOT NULL,
    [Move Time] DECIMAL(38,20) NOT NULL,
    [company] CHAR(3) NOT NULL DEFAULT (''),
    CONSTRAINT [pk_bc_sql_cus_RoutingLine] PRIMARY KEY (company,Operation No_,Routing No_,Version Code)
);
