CREATE TABLE [nav2017_cus].[ProductGroup] (
    [Item Category Code] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(10) NOT NULL,
    [Description] NVARCHAR(50) NOT NULL,
    CONSTRAINT [PK_nav2017_cus_ProductGroup] PRIMARY KEY (Code,Item Category Code)
);
