CREATE TABLE [nav2017_cus].[CustomColumns_StockKeepingUnit] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(255) NOT NULL,
    [Replenishment System] NVARCHAR(255) NULL,
    CONSTRAINT [PK_nav2017_cus_CustomColumns_StockKeepingUnit] PRIMARY KEY (Item No_,Location Code)
);
