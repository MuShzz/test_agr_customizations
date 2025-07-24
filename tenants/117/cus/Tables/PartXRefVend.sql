CREATE TABLE [cus].[PartXRefVend] (
    [PartNum] NVARCHAR(50) NOT NULL,
    [VendorNum] INT NOT NULL,
    [VendPartNum] NVARCHAR(50) NOT NULL,
    [MfgNum] INT NOT NULL,
    [MfgPartNum] NVARCHAR(50) NOT NULL,
    [LeadTime] INT NULL,
    [PurchaseDefault] BIT NULL,
    CONSTRAINT [pk_cus_PartXRefVend] PRIMARY KEY (MfgNum,MfgPartNum,PartNum,VendorNum,VendPartNum)
);
