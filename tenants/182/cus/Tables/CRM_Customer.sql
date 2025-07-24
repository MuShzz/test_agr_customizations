CREATE TABLE [cus].[CRM_Customer] (
    [pkCustomerId] NVARCHAR(255) NOT NULL,
    [CompanyName] NVARCHAR(255) NOT NULL,
    [Name] NVARCHAR(127) NOT NULL,
    [Address1] NVARCHAR(255) NOT NULL,
    [Address2] NVARCHAR(255) NOT NULL,
    [Address3] NVARCHAR(255) NOT NULL,
    [Region] NVARCHAR(255) NOT NULL,
    [Town] NVARCHAR(255) NULL,
    [fkCountryId] NVARCHAR(255) NOT NULL,
    [Telephone] NVARCHAR(64) NOT NULL,
    [Email] NVARCHAR(255) NOT NULL,
    [SecondaryPhone] NVARCHAR(64) NOT NULL,
    [SecondaryEmail] NVARCHAR(255) NOT NULL,
    [CameFrom] NVARCHAR(64) NOT NULL,
    [postcode] NVARCHAR(127) NOT NULL,
    [CreatedOn] NVARCHAR(64) NOT NULL,
    [AccountNumber] NVARCHAR(64) NULL
);
