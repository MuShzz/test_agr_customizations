CREATE TABLE [cus].[SalesShipmentHeader] (
    [No_] NVARCHAR(20) NOT NULL,
    [Order No_] NVARCHAR(20) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_SalesShipmentHeader] PRIMARY KEY (Company,No_)
);
