CREATE TABLE [cus].[purch_price] (
    [CurrencyCode] VARCHAR(10) NOT NULL,
    [ItemNo] VARCHAR(20) NOT NULL,
    [MinimumQuantity] DECIMAL(18,4) NOT NULL,
    [StartingDate] DATE NOT NULL,
    [UnitofMeasureCode] VARCHAR(10) NOT NULL,
    [VariantCode] VARCHAR(10) NOT NULL,
    [VendorNo] VARCHAR(20) NOT NULL,
    [DirectUnitCost] DECIMAL(18,4) NULL,
    [EndingDate] DATE NULL,
    CONSTRAINT [PK_cus_purch_price] PRIMARY KEY (CurrencyCode,ItemNo,MinimumQuantity,StartingDate,UnitofMeasureCode,VariantCode,VendorNo)
);
