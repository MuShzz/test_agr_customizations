CREATE TABLE [bc_rest_cus].[customer] (
    [No] NVARCHAR(20) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    [Blocked] NVARCHAR(30) NOT NULL,
    [GlobalDimension2Code] NVARCHAR(30) NULL,
    CONSTRAINT [PK_bc_rest_cus_customer] PRIMARY KEY (No)
);
