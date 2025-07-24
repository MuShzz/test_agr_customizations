CREATE TABLE [bc_sql_cus].[ICEWishlist] (
    [Entry No_] INT NOT NULL,
    [Date of Registration] DATETIME NOT NULL,
    [Time of Registration] DATETIME NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [Phone Number] NVARCHAR(30) NOT NULL,
    [Item Category Code] NVARCHAR(20) NOT NULL,
    [Product Group Code] NVARCHAR(20) NOT NULL,
    [Item Family Code] NVARCHAR(20) NOT NULL,
    [Item Reference No_] NVARCHAR(50) NOT NULL,
    [Quantity] DECIMAL(38,20) NOT NULL,
    [Unit Price] DECIMAL(38,20) NOT NULL,
    [Date SMS sent] DATETIME NOT NULL,
    [Time SMS sent] DATETIME NOT NULL,
    [Store No_] NVARCHAR(10) NOT NULL,
    [Location Code] NVARCHAR(10) NOT NULL,
    CONSTRAINT [PK_bc_sql_cus_ICEWishlist] PRIMARY KEY (Entry No_)
);
