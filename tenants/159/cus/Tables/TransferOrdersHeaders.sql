CREATE TABLE [cus].[TransferOrdersHeaders] (
    [pkTransferId] NVARCHAR(255) NULL,
    [fkFromLocationId] NVARCHAR(255) NULL,
    [fkToLocationId] NVARCHAR(255) NULL,
    [Status] NVARCHAR(255) NULL,
    [ReferenceNumber] NVARCHAR(255) NULL,
    [OrderDate] NVARCHAR(255) NULL,
    [bLogicalDelete] NVARCHAR(255) NULL,
    [fkOriginalTransferId] NVARCHAR(255) NULL
);
