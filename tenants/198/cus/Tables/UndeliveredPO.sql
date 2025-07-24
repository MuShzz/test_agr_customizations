CREATE TABLE [cus].[UndeliveredPO] (
    [PurchaseOrder] NVARCHAR(128) NULL,
    [PurchaseOrderItem] NVARCHAR(128) NULL,
    [SequentialNumber] NVARCHAR(128) NULL,
    [ConfirmationCategory] NVARCHAR(128) NULL,
    [DeliveryDate] DATETIME2 NULL,
    [Quantity] NVARCHAR(128) NULL,
    [CreatedOn] DATETIME2 NULL,
    [InboundDelivery] NVARCHAR(128) NULL
);
