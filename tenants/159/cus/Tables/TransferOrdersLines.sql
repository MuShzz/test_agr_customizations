CREATE TABLE [cus].[TransferOrdersLines] (
    [pkTransferItemId] NVARCHAR(255) NULL,
    [fkTransferId] NVARCHAR(255) NULL,
    [fkStockItemId] NVARCHAR(255) NULL,
    [RequestedQuantity] NVARCHAR(255) NULL,
    [Closed] NVARCHAR(255) NULL,
    [UnitValue] NVARCHAR(255) NULL
);
