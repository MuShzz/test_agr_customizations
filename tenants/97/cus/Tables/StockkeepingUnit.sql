CREATE TABLE [cus].[StockkeepingUnit] (
    [Location Code] NVARCHAR(10) NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    [Variant Code] NVARCHAR(10) NOT NULL,
    [Unit Cost] DECIMAL(38,20) NOT NULL,
    [Replenishment System] INT NOT NULL,
    [Transfer-from Code] NVARCHAR(10) NOT NULL,
    [Lead Time Calculation] VARCHAR(32) NOT NULL,
    [Minimum Order Quantity] DECIMAL(38,20) NOT NULL,
    [Safety Stock Quantity] DECIMAL(38,20) NOT NULL,
    [Order Multiple] DECIMAL(38,20) NOT NULL,
    [Reorder Point] DECIMAL(38,20) NOT NULL,
    [Maximum Inventory] DECIMAL(38,20) NOT NULL,
    [Vendor No_] NVARCHAR(20) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_StockkeepingUnit] PRIMARY KEY (Company,Item No_,Location Code,Variant Code)
);
