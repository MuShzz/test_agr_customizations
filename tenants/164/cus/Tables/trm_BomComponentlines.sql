CREATE TABLE [cus].[trm_BomComponentlines] (
    [BOM_Type] NVARCHAR(20) NULL,
    [BOM_Item_No] NVARCHAR(50) NULL,
    [Version] INT NULL,
    [Line_No] INT NULL,
    [Type] NVARCHAR(20) NULL,
    [No] VARCHAR(20) NULL,
    [Quantity_per] DECIMAL(18,4) NULL,
    [Unit_of_Measure_Code] NVARCHAR(10) NULL,
    [Company] NVARCHAR(3) NOT NULL
);
