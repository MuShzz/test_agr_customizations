CREATE TABLE [nav_cus].[ItemUnitofMeasure] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(10) NOT NULL,
    [Qty_ per Unit of Measure] DECIMAL(38,20) NOT NULL,
    [Length] DECIMAL(38,20) NOT NULL,
    [Width] DECIMAL(38,20) NOT NULL,
    [Height] DECIMAL(38,20) NOT NULL,
    [Cubage] DECIMAL(38,20) NOT NULL,
    [Weight] DECIMAL(38,20) NOT NULL,
    [Description] NVARCHAR(255) NULL,
    CONSTRAINT [pk_nav_cus_ItemUnitofMeasure] PRIMARY KEY (Code,Item No_)
);
