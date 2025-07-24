CREATE TABLE [cus].[import_product_units] (
    [ItemCode] NVARCHAR(128) NULL,
    [UnitCode] NVARCHAR(128) NULL,
    [UnitQuantity] DECIMAL(18,4) NULL,
    [DefaultSaleQuantity] DECIMAL(18,4) NULL,
    [UnitPriceRatio] DECIMAL(18,4) NULL,
    [NetWeight] DECIMAL(18,4) NULL,
    [UnitPrice] DECIMAL(18,4) NULL,
    [UnitPriceWithTax] DECIMAL(18,4) NULL,
    [QuantityOnHand] DECIMAL(18,4) NULL
);
