CREATE TABLE [cus].[Location] (
    [id] INT NOT NULL,
    [name] NVARCHAR(MAX) NULL,
    [fullname] NVARCHAR(MAX) NULL,
    [isinactive] NVARCHAR(MAX) NULL,
    [makeinventoryavailable] NVARCHAR(MAX) NULL,
    [makeinventoryavailablestore] NVARCHAR(MAX) NULL,
    CONSTRAINT [PK_Location] PRIMARY KEY (id)
);
