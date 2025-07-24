CREATE TABLE [cus].[order_header_total] (
    [oht_id] INT NOT NULL,
    [oht_oh_id] NVARCHAR(30) NOT NULL,
    [oht_total_quantity] DECIMAL(18,4) NULL,
    CONSTRAINT [pk_cus_order_header_total] PRIMARY KEY (oht_id)
);
