CREATE TABLE [bc_sql_cus].[SalesHeader_WePet] (
    [Document Type] INT NOT NULL,
    [No_] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(10) NOT NULL,
    [Sell-to Customer No_] NVARCHAR(20) NOT NULL,
    [Requested Delivery Date] DATETIME NOT NULL,
    [Promised Delivery Date] DATETIME NOT NULL,
    [Status] INT NOT NULL,
    [company] CHAR(3) NOT NULL DEFAULT (''),
    CONSTRAINT [pk_bc_sql_cus_SalesHeader_WePet] PRIMARY KEY (company,Document Type,No_)
);
