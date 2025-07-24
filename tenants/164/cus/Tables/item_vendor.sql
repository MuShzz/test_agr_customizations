CREATE TABLE [cus].[item_vendor] (
    [ItemNo] NVARCHAR(20) NOT NULL,
    [LeadTimeCalculation] NVARCHAR(10) NULL,
    [VariantCode] NVARCHAR(20) NOT NULL,
    [VendorItemNo] NVARCHAR(50) NOT NULL,
    [VendorNo] NVARCHAR(20) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [pk_cus_item_vendor] PRIMARY KEY (Company,ItemNo,VariantCode,VendorNo)
);
