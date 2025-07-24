CREATE TABLE [cus].[bom_consumption] (
    [transaction_id] BIGINT NOT NULL,
    [product_item_no] NVARCHAR(255) NOT NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [date] DATE NOT NULL,
    [value] DECIMAL(18,4) NOT NULL,
    CONSTRAINT [PK_cus_bom_consumption] PRIMARY KEY (transaction_id)
);
