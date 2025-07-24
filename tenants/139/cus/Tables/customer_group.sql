CREATE TABLE [cus].[customer_group] (
    [Dimension_Code] NVARCHAR(20) NOT NULL,
    [Code] NVARCHAR(20) NOT NULL,
    [Name] NVARCHAR(50) NOT NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_cus_customer_group] PRIMARY KEY (Code,Company,Dimension_Code)
);
