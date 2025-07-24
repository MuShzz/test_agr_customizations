CREATE TABLE [cus].[CustomItemInventory] (
    [ListID] NVARCHAR(255) NOT NULL,
    [Name] NVARCHAR(255) NOT NULL,
    [CustomFieldLeadTimeDays] INT NULL,
    [TimeCreated] DATETIME2 NULL,
    [TimeModified] DATETIME2 NULL,
    [CustomFieldCatalogItem] VARCHAR(20) NULL,
    CONSTRAINT [PK_cus_CustomItemInventory] PRIMARY KEY (ListID)
);
