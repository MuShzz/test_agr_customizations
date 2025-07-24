CREATE TABLE [cus].[purchase_order_line] (
    [pol_id] INT NOT NULL,
    [pol_poh_id] INT NULL,
    [pol_vad_id] INT NULL,
    [pol_sl_id] INT NOT NULL,
    [pol_qty_ordered] DECIMAL(18,4) NULL,
    [pol_qty_received] DECIMAL(18,4) NULL,
    [pol_date_promised] DATETIME NULL,
    [pol_pos_id] INT NULL,
    [pol_direct_oli_id] INT NULL,
    [pol_direct] BIT NULL,
    [pol_back_to_back_oli_id] INT NULL,
    CONSTRAINT [pk_cus_purchase_order_line] PRIMARY KEY (pol_id)
);
