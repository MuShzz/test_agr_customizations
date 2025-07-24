CREATE TABLE [nav_cus].[SalesLineDiscount] (
    [Type] INT NOT NULL,
    [Code] NVARCHAR(20) NOT NULL,
    [Sales Type] INT NOT NULL,
    [Sales Code] NVARCHAR(20) NOT NULL,
    [Starting Date] DATE NOT NULL,
    [Currency Code] NVARCHAR(10) NOT NULL,
    [Variant Code] NVARCHAR(10) NOT NULL,
    [Unit of Measure Code] NVARCHAR(10) NOT NULL,
    [Minimum Quantity] DECIMAL(38,20) NOT NULL,
    [Line Discount _] DECIMAL(38,20) NOT NULL,
    [Ending Date] DATE NOT NULL,
    [Contract No_] NVARCHAR(10) NULL,
    [Type of Contract] INT NULL,
    CONSTRAINT [pk_SalesLine] PRIMARY KEY (Code,Currency Code,Minimum Quantity,Sales Code,Sales Type,Starting Date,Type,Unit of Measure Code,Variant Code)
);
