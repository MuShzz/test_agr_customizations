CREATE TABLE [cus].[Customer] (
    [No_] NVARCHAR(20) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    [Blocked] INT NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_Customer] PRIMARY KEY (Company,No_)
);
