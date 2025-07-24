CREATE TABLE [nav2017_cus].[CustomColumns_Item] (
    [No_] NVARCHAR(20) NOT NULL,
    [Discontinued] INT NULL,
    [Item Classification] NVARCHAR(50) NULL,
    [Product Group Code] NVARCHAR(50) NULL,
    CONSTRAINT [pk_ItemCC] PRIMARY KEY (No_)
);
