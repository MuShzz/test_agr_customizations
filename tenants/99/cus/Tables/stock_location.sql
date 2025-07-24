CREATE TABLE [cus].[stock_location] (
    [sl_id] INT NOT NULL,
    [sl_name] NVARCHAR(100) NULL,
    [sl_address1] NVARCHAR(250) NULL,
    [sl_address2] NVARCHAR(250) NULL,
    [sl_town] NVARCHAR(250) NULL,
    [sl_county] NVARCHAR(250) NULL,
    [sl_country] NVARCHAR(250) NULL,
    [sl_postcode] NVARCHAR(250) NULL,
    [sl_telephone] NVARCHAR(250) NULL,
    [sl_contact] NVARCHAR(250) NULL,
    [sl_country_code] NVARCHAR(250) NULL,
    CONSTRAINT [pk_cus_stock_location] PRIMARY KEY (sl_id)
);
