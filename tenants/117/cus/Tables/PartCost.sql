CREATE TABLE [cus].[PartCost] (
    [PartNum] NVARCHAR(50) NULL,
    [CostID] NVARCHAR(50) NULL,
    [AvgLaborCost] DECIMAL(18,4) NULL,
    [AvgBurdenCost] DECIMAL(18,4) NULL,
    [AvgMaterialCost] DECIMAL(18,4) NULL,
    [AvgSubContCost] DECIMAL(18,4) NULL,
    [AvgMtlBurCost] DECIMAL(18,4) NULL,
    [StdLaborCost] DECIMAL(18,4) NULL,
    [StdBurdenCost] DECIMAL(18,4) NULL,
    [StdMaterialCost] DECIMAL(18,4) NULL,
    [StdSubContCost] DECIMAL(18,4) NULL,
    [StdMtlBurCost] DECIMAL(18,4) NULL
);
