CREATE TABLE [cus].[InventorySite] (
    [ListID] NVARCHAR(36) NOT NULL,
    [TimeCreated] DATETIME2 NULL,
    [TimeModified] DATETIME2 NULL,
    [EditSequence] NVARCHAR(16) NULL,
    [Name] NVARCHAR(31) NULL,
    [IsActive] BIT NULL,
    [ParentSiteRefListID] NVARCHAR(36) NULL,
    [ParentSiteRefFullName] NVARCHAR(209) NULL,
    [IsDefaultSite] BIT NULL,
    [SiteDesc] NVARCHAR(100) NULL,
    [Contact] NVARCHAR(41) NULL,
    [Phone] NVARCHAR(21) NULL,
    [Fax] NVARCHAR(21) NULL,
    [Email] NVARCHAR(1024) NULL,
    CONSTRAINT [PK_InventorySite] PRIMARY KEY (ListID)
);
