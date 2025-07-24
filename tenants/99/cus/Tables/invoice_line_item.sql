CREATE TABLE [cus].[invoice_line_item] (
    [ili_id] INT NOT NULL,
    [ili_oli_id] INT NOT NULL,
    [ili_vad_id] INT NOT NULL,
    [ili_ih_id] INT NOT NULL,
    CONSTRAINT [pk_cus_invoice_line_item] PRIMARY KEY (ili_id)
);
