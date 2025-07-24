CREATE TABLE [bc_rest_cus].[prod_order_line] (
    [ProdOrderNo] NVARCHAR(20) NOT NULL,
    [LineNo] INT NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [ItemNo] NVARCHAR(100) NULL,
    [VariantCode] NVARCHAR(20) NULL,
    [ScrapPct] DECIMAL(38,20) NULL,
    [LocationCode] NVARCHAR(50) NULL,
    [DueDate] DATETIME2 NULL,
    [RemainingQuantity] DECIMAL(38,20) NULL,
    [FinishedQuantity] DECIMAL(38,20) NULL,
    [FinishedQtyBase] DECIMAL(38,20) NULL,
    [UnitofMeasureCode] NVARCHAR(10) NULL,
    [ProductionBOMNo] NVARCHAR(20) NULL,
    CONSTRAINT [PK_bc_rest_cus_prod_order_line] PRIMARY KEY (LineNo,ProdOrderNo,Status)
);
