CREATE TABLE [cus].[CustomVendor] (
    [ListID] NVARCHAR(255) NOT NULL,
    [Name] NVARCHAR(41) NULL,
    [CustomFieldStandardLeadtimeDays] INT NULL,
    [TimeCreated] DATETIME2 NULL,
    [TimeModified] DATETIME2 NULL,
    CONSTRAINT [PK_cus_CustomVendor] PRIMARY KEY (ListID)
);
