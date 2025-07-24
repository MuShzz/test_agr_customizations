CREATE TABLE [cus].[location] (
    [Code] VARCHAR(10) NOT NULL,
    [Name] VARCHAR(100) NOT NULL,
    [City] VARCHAR(30) NOT NULL,
    [PostCode] VARCHAR(20) NOT NULL,
    [County] VARCHAR(30) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [pk_cus_location] PRIMARY KEY (Code,Company)
);
