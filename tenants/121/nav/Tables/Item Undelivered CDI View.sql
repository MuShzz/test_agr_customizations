CREATE TABLE [nav_cus].[Item Undelivered CDI View] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(20) NOT NULL,
    [Order No_] NVARCHAR(255) NOT NULL,
    [Expected Receipt Date] DATETIME NOT NULL,
    [Quantity] DECIMAL(18,4) NULL,
    [Qty_ to Receive] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_nav_cus_undelivered_cdi] PRIMARY KEY (Expected Receipt Date,Item No_,Location Code,Order No_)
);
