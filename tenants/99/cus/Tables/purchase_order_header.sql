CREATE TABLE [cus].[purchase_order_header] (
    [poh_id] INT NOT NULL,
    [poh_order_number] NVARCHAR(30) NOT NULL,
    [poh_pos_id] INT NULL,
    [poh_sd_id] INT NULL,
    [poh_promised_date] DATETIME NULL,
    CONSTRAINT [pk_cus_purchase_order_header] PRIMARY KEY (poh_id)
);
