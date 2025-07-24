CREATE TABLE [nav_cus].[SalesPrice] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Sales Type] INT NOT NULL,
    [Sales Code] NVARCHAR(20) NOT NULL,
    [Starting Date] DATE NOT NULL,
    [Currency Code] NVARCHAR(10) NOT NULL,
    [Variant Code] NVARCHAR(10) NOT NULL,
    [Unit of Measure Code] NVARCHAR(10) NOT NULL,
    [Minimum Quantity] DECIMAL(38,20) NOT NULL,
    [Unit Price] DECIMAL(38,20) NOT NULL,
    [Ending Date] DATE NOT NULL,
    [Contract No_] NVARCHAR(10) NULL,
    [Type of Contract] INT NULL,
    CONSTRAINT [pk_SalesPrice] PRIMARY KEY (Currency Code,Item No_,Minimum Quantity,Sales Code,Sales Type,Starting Date,Unit of Measure Code,Variant Code)
);
