CREATE TABLE [cus].[ProductSupplyPlanning] (
    [Product] NVARCHAR(128) NOT NULL,
    [Plant] NVARCHAR(128) NOT NULL,
    [LotSizeRoundingQuantity] NVARCHAR(128) NULL,
    [LotSizingProcedure] NVARCHAR(128) NULL,
    [MRPType] NVARCHAR(128) NULL,
    [MRPResponsible] NVARCHAR(128) NULL,
    [SafetyStockQuantity] NVARCHAR(128) NULL,
    [ABCIndicator] NVARCHAR(128) NULL,
    [MaximumStockQuantity] NVARCHAR(128) NULL,
    [ReorderThresholdQuantity] NVARCHAR(128) NULL,
    [PlannedDeliveryDurationInDays] NVARCHAR(128) NULL,
    [TotalReplenishmentLeadTime] NVARCHAR(128) NULL,
    [BaseUnit] NVARCHAR(128) NULL,
    [Currency] NVARCHAR(128) NULL,
    CONSTRAINT [PK_erp_cus_ProductSupplyPlanning] PRIMARY KEY (Plant,Product)
);
