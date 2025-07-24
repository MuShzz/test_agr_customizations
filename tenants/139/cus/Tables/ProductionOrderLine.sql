CREATE TABLE [cus].[ProductionOrderLine] (
    [Prod_Order_No] VARCHAR(20) NOT NULL,
    [Status] VARCHAR(50) NOT NULL,
    [Line_No] INT NOT NULL,
    [Item_No] VARCHAR(20) NOT NULL,
    [Variant_Code] VARCHAR(10) NOT NULL,
    [Location_Code] VARCHAR(10) NOT NULL,
    [Ending_Date] DATE NOT NULL,
    [Remaining_Quantity] DECIMAL(38,20) NOT NULL,
    [Company] NVARCHAR(100) NOT NULL,
    [Due_Date] DATE NULL,
    CONSTRAINT [pk_cus_ProductionOrderLine] PRIMARY KEY (Line_No,Prod_Order_No,Status)
);
