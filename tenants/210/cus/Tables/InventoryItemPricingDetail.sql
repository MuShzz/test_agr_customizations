CREATE TABLE [cus].[InventoryItemPricingDetail] (
    [ItemCode] NVARCHAR(30) NOT NULL,
    [CurrencyCode] NVARCHAR(30) NOT NULL,
    [RetailPriceRate] DECIMAL(18,6) NULL,
    [StandardCostRate] DECIMAL(18,6) NULL,
    [PricingCostRate] DECIMAL(18,6) NULL,
    [WholesalePriceRate] DECIMAL(18,6) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_InventoryItemPricingDetail] PRIMARY KEY (CurrencyCode,ItemCode)
);
