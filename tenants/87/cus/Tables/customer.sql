CREATE TABLE [cus].[customer] (
    [No] NVARCHAR(20) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    [Blocked] NVARCHAR(30) NOT NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_cus_customer] PRIMARY KEY (Company,No)
);
