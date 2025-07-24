CREATE TABLE [cus].[Location] (
    [Code] NVARCHAR(10) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    [City] NVARCHAR(30) NOT NULL,
    [Post Code] NVARCHAR(20) NOT NULL,
    [County] NVARCHAR(30) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_Location] PRIMARY KEY (Code,Company)
);
