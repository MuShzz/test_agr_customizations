CREATE TABLE [cus].[Vendor] (
    [No_] NVARCHAR(20) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    [Purchaser Code] NVARCHAR(20) NOT NULL,
    [Lead Time Calculation] VARCHAR(32) NOT NULL,
    [City] NVARCHAR(30) NOT NULL,
    [Blocked] INT NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    [Order Frequency] NVARCHAR(20) NULL,
    [Process Period] NVARCHAR(20) NULL,
    [Transport Period] NVARCHAR(20) NULL,
    [Receipt Period] NVARCHAR(20) NULL,
    CONSTRAINT [PK_cus_Vendor] PRIMARY KEY (Company,No_)
);
