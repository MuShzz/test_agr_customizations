CREATE TABLE [bc_sql_cus].[ICEAGRSalesHistory] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(10) NOT NULL,
    [Posting Date] DATETIME NOT NULL,
    [Entry Type] INT NOT NULL,
    [Quantity] DECIMAL(38,20) NOT NULL,
    CONSTRAINT [PK_bc_sql_cus_ICEAGRSalesHistory] PRIMARY KEY (Entry Type,Item No_,Location Code,Posting Date)
);
