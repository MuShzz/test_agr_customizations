CREATE TABLE [cus].[PLACE_HOLDER_LANDING_TABLE] (
    [No_] NVARCHAR(20) NOT NULL,
    [Vendor No_] NVARCHAR(20) NOT NULL,
    [Vendor Item No_] NVARCHAR(50) NOT NULL,
    [Description] NVARCHAR(255) NOT NULL,
    [Description 2] NVARCHAR(1000) NULL,
    [Type] INT NOT NULL,
    [Item Category Code] NVARCHAR(20) NOT NULL,
    [Blocked] TINYINT NOT NULL,
    [Purchasing Blocked] TINYINT NOT NULL,
    [Gross Weight] DECIMAL(38,20) NOT NULL,
    [Unit Volume] DECIMAL(38,20) NOT NULL,
    [Unit Cost] DECIMAL(38,20) NOT NULL,
    [Order Multiple] DECIMAL(38,20) NOT NULL,
    [Maximum Inventory] DECIMAL(38,20) NOT NULL,
    [Unit Price] DECIMAL(38,20) NOT NULL,
    [Base Unit of Measure] NVARCHAR(10) NOT NULL,
    [Minimum Order Quantity] DECIMAL(38,20) NOT NULL,
    [Price Includes VAT] TINYINT NOT NULL,
    [Production BOM No_] NVARCHAR(20) NOT NULL,
    [Last Direct Cost] DECIMAL(38,20) NOT NULL,
    [Lead Time Calculation] VARCHAR(32) NOT NULL,
    [Replenishment System] INT NOT NULL,
    [Purch_ Unit of Measure] NVARCHAR(10) NOT NULL,
    [Reordering Policy] INT NOT NULL,
    [Safety Stock Quantity] DECIMAL(38,20) NOT NULL,
    [Reorder Point] DECIMAL(38,20) NOT NULL,
    CONSTRAINT [pk_PLACEHOLDERTABLE1] PRIMARY KEY (No_)
);
