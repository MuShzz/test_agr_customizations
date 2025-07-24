CREATE TABLE [dk_cus].[AGREssentials_items] (
    [itemId] INT NOT NULL,
    [itemName] NVARCHAR(255) NULL,
    [itemNo] NVARCHAR(255) NULL,
    [locationName] NVARCHAR(255) NULL,
    [locationNo] NVARCHAR(255) NULL,
    [stockUnits] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_AGREssentials_items] PRIMARY KEY (itemId)
);
