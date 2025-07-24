CREATE TABLE [cus].[Part] (
    [PartNum] NVARCHAR(50) NULL,
    [PartDescription] NVARCHAR(255) NULL,
    [ClassID] NVARCHAR(50) NULL,
    [IUM] NVARCHAR(10) NULL,
    [PUM] NVARCHAR(10) NULL,
    [ProdCode] NVARCHAR(50) NULL,
    [GrossWeight] FLOAT(53) NULL,
    [GrossWeightUOM] NVARCHAR(10) NULL,
    [FSSalesUnitPrice] FLOAT(53) NULL,
    [Part_FFS_Overide_c] NVARCHAR(50) NULL,
    [InActive] BIT NULL,
    [CostMethod] NVARCHAR(2) NULL,
    [UnitPrice] DECIMAL(18,4) NULL
);
