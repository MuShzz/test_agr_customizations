CREATE TABLE [cus].[InventoryCategory] (
    [ItemCode] NVARCHAR(30) NOT NULL,
    [CategoryCode] NVARCHAR(30) NOT NULL,
    [IsPrimary] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryCategory] PRIMARY KEY (CategoryCode,ItemCode)
);
