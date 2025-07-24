CREATE TABLE [cus].[Customer] (
    [id] INT NOT NULL,
    [altname] NVARCHAR(MAX) NULL,
    [companyname] NVARCHAR(MAX) NULL,
    [entityid] NVARCHAR(MAX) NULL,
    [entitynumber] NVARCHAR(MAX) NULL,
    [entitytitle] NVARCHAR(MAX) NULL,
    [isinactive] NVARCHAR(MAX) NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY (id)
);
