CREATE TABLE [cus].[vendor] (
    [No] VARCHAR(20) NOT NULL,
    [Name] VARCHAR(100) NOT NULL,
    [PurchaserCode] VARCHAR(10) NOT NULL,
    [LeadTimeCalculation] VARCHAR(32) NOT NULL,
    [City] VARCHAR(30) NOT NULL,
    [Blocked] VARCHAR(10) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [pk_cus_vendor] PRIMARY KEY (Company,No)
);
