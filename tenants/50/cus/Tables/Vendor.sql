CREATE TABLE [cus].[Vendor] (
    [id] INT NOT NULL,
    [altname] NVARCHAR(100) NULL,
    [companyname] NVARCHAR(100) NULL,
    [entityid] NVARCHAR(100) NULL,
    [entitynumber] INT NULL,
    [entitytitle] NVARCHAR(255) NULL,
    [externalid] NVARCHAR(100) NULL,
    [isinactive] NVARCHAR(1) NULL,
    [predicteddays] INT NULL,
    CONSTRAINT [PK_Vendor] PRIMARY KEY (id)
);
