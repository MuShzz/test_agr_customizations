CREATE TABLE [cus].[InventoryKitDetail] (
    [ItemKitCode] NVARCHAR(30) NOT NULL,
    [ItemCode] NVARCHAR(30) NOT NULL,
    [GroupCode] NVARCHAR(30) NOT NULL,
    [UnitMeasureCode] NVARCHAR(30) NULL,
    [Quantity] DECIMAL(18,6) NULL,
    [IsDefault] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryKitDetail] PRIMARY KEY (GroupCode,ItemCode,ItemKitCode)
);
