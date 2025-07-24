CREATE TABLE [cus].[customer_extra_info] (
    [No] NVARCHAR(20) NOT NULL,
    [GlobalDimension1Code] NVARCHAR(20) NOT NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_cus_customer_extra_info] PRIMARY KEY (Company,No)
);
