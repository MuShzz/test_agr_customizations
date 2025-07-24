CREATE TABLE [cus].[PartPlant] (
    [Plant] NVARCHAR(50) NULL,
    [PartNum] NVARCHAR(50) NULL,
    [MinimumQty] FLOAT(53) NULL,
    [MaximumQty] FLOAT(53) NULL,
    [SafetyQty] FLOAT(53) NULL,
    [MinOrderQty] FLOAT(53) NULL,
    [LeadTime] FLOAT(53) NULL,
    [VendorNum] INT NULL,
    [ReOrderLevel] BIT NULL,
    [TransferPlant] NVARCHAR(50) NULL,
    [BuyerID] NVARCHAR(50) NULL,
    [MinMfgLotSize] DECIMAL(18,4) NULL,
    [MfgLotMultiple] DECIMAL(18,4) NULL,
    [SourceType] NVARCHAR(2) NULL
);
