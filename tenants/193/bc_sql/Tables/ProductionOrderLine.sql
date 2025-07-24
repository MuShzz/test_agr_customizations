CREATE TABLE [bc_sql_cus].[ProductionOrderLine] (
    [Prod_ Order No_] NVARCHAR(20) NOT NULL,
    [Line No_] INT NOT NULL,
    [Status] INT NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [Item No_] NVARCHAR(100) NULL,
    [Variant Code] NVARCHAR(10) NULL,
    [Production BOM No_] NVARCHAR(100) NULL,
    [Starting Date] DATETIME NULL,
    [Ending Time] DATETIME NULL,
    [Ending Date] DATETIME NULL,
    [Due Date] DATETIME NULL,
    [Location Code] NVARCHAR(50) NULL,
    [Bin Code] NVARCHAR(50) NULL,
    [Quantity] DECIMAL(38,20) NULL,
    [Finished Quantity] DECIMAL(38,20) NULL,
    [Remaining Quantity] DECIMAL(38,20) NULL,
    CONSTRAINT [pk_ProductionOrderLine] PRIMARY KEY (Line No_,Prod_ Order No_,Status)
);
