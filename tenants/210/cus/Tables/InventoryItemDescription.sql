CREATE TABLE [cus].[InventoryItemDescription] (
    [ItemCode] NVARCHAR(30) NOT NULL,
    [LanguageCode] NVARCHAR(50) NOT NULL,
    [ItemDescription] NVARCHAR(1000) NULL,
    [ExtendedDescription] NVARCHAR(1000) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryItemDescription] PRIMARY KEY (ItemCode,LanguageCode)
);
