CREATE TABLE [cus].[InventoryItemLocations] (
    [item] INT NOT NULL,
    [location] INT NOT NULL,
    [item_code] NVARCHAR(100) NULL,
    [location_name] NVARCHAR(100) NULL,
    [atpleadtime] INT NULL,
    [quantityavailable] DECIMAL(18,4) NULL,
    [quantitybackordered] DECIMAL(18,4) NULL,
    [quantitycommitted] DECIMAL(18,4) NULL,
    [quantityonhand] DECIMAL(18,4) NULL,
    [quantityonorder] DECIMAL(18,4) NULL,
    [supplytype] NVARCHAR(100) NULL,
    [leadtime] INT NULL,
    [averagecostmli] DECIMAL(18,4) NULL,
    [lastpurchasepricemli] DECIMAL(18,4) NULL,
    [fixedlotmultiple] DECIMAL(18,4) NULL,
    [fixedlotsize] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_InventoryItemLocations] PRIMARY KEY (item,location)
);
