CREATE TABLE [cus].[Part_CustomColumns] (
    [PartNum] NVARCHAR(50) NOT NULL,
    [OnHold] BIT NULL,
    [InActive] BIT NULL,
    [RunOut] BIT NULL,
    [CsgCataloguePart_c] NVARCHAR(50) NULL,
    [CommercialBrand] NVARCHAR(50) NULL,
    [CommercialSubBrand] NVARCHAR(50) NULL,
    CONSTRAINT [pk_cus_Part_CustomColumns] PRIMARY KEY (PartNum)
);
