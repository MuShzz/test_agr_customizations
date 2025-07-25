CREATE TABLE [cus].[Customer] (
    [ListID] NVARCHAR(36) NOT NULL,
    [TimeCreated] DATETIME2 NULL,
    [TimeModified] DATETIME2 NULL,
    [EditSequence] NVARCHAR(16) NULL,
    [Name] NVARCHAR(41) NULL,
    [FullName] NVARCHAR(209) NULL,
    [IsActive] BIT NULL,
    [ClassRefListID] NVARCHAR(36) NULL,
    [ClassRefFullName] NVARCHAR(209) NULL,
    [ParentRefListID] NVARCHAR(36) NULL,
    [ParentRefFullName] NVARCHAR(209) NULL,
    [Sublevel] INT NULL,
    [CompanyName] NVARCHAR(41) NULL,
    [Salutation] NVARCHAR(15) NULL,
    [CustomerTypeRefListID] NVARCHAR(36) NULL,
    [CustomerTypeRefFullName] NVARCHAR(159) NULL,
    [TermsRefListID] NVARCHAR(36) NULL,
    [TermsRefFullName] NVARCHAR(31) NULL,
    [SalesRepRefListID] NVARCHAR(36) NULL,
    [SalesRepRefFullName] NVARCHAR(5) NULL,
    [ResaleNumber] NVARCHAR(15) NULL,
    [AccountNumber] NVARCHAR(99) NULL,
    [BusinessNumber] NVARCHAR(99) NULL,
    [CreditLimit] DECIMAL(15,2) NULL,
    [JobStatus] NVARCHAR(10) NULL,
    [JobStartDate] DATETIME2 NULL,
    [JobProjectedEndDate] DATETIME2 NULL,
    [JobEndDate] DATETIME2 NULL,
    [JobDesc] NVARCHAR(99) NULL,
    [JobTypeRefListID] NVARCHAR(36) NULL,
    [JobTypeRefFullName] NVARCHAR(159) NULL,
    [Notes] NVARCHAR(MAX) NULL,
    [PreferredDeliveryMethod] NVARCHAR(10) NULL,
    [ExternalGUID] NVARCHAR(40) NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY (ListID)
);
