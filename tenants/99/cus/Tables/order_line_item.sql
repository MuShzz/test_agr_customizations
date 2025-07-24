CREATE TABLE [cus].[order_line_item] (
    [oli_id] INT NOT NULL,
    [oli_oh_id] INT NULL,
    [oli_sl_id] INT NULL,
    [oli_pol_id] INT NULL,
    [oli_rsp_net] DECIMAL(18,4) NULL,
    [oli_vad_id] INT NULL,
    [oli_original_oli_id] INT NULL,
    [oli_qty_required] DECIMAL(18,4) NULL,
    [oli_date_promised] DATETIME NULL,
    [oli_os_id] INT NULL,
    [oli_qty_sent] DECIMAL(18,4) NULL,
    [oli_qty_tbsent] DECIMAL(18,4) NULL,
    [oli_direct] BIT NULL,
    [oli_back_to_back] NVARCHAR(20) NULL,
    CONSTRAINT [pk_cus_order_line_item] PRIMARY KEY (oli_id)
);
