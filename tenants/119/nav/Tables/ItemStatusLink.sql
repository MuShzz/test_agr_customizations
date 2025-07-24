CREATE TABLE [nav_cus].[ItemStatusLink] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Starting Date] DATETIME NOT NULL,
    [Block Purchasing] TINYINT NOT NULL,
    CONSTRAINT [PK_nav_cus_ItemStatusLink] PRIMARY KEY (Item No_,Starting Date)
);
