CREATE TABLE [cus].[currency] (
    [c_id] INT NOT NULL,
    [c_description] NVARCHAR(255) NOT NULL,
    [c_exchange_rate] DECIMAL(18,4) NOT NULL,
    [c_currency_code] NVARCHAR(10) NULL,
    [c_currency_symbol] NVARCHAR(10) NULL,
    [c_currency_is_base] BIT NULL,
    [c_last_amended_datetime] DATETIME NULL,
    [c_input_datetime] DATETIME NULL,
    CONSTRAINT [pk_cus_currency] PRIMARY KEY (c_id)
);
