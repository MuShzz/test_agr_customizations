CREATE TABLE [cus].[purchase_order] (
    [no] NVARCHAR(128) NOT NULL,
    [original_po_no] NVARCHAR(128) NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [vendor_no] NVARCHAR(255) NOT NULL,
    [delivery_date] DATE NULL,
    [deliv_status] TINYINT NOT NULL,
    CONSTRAINT [PK_cus_purchase_order] PRIMARY KEY (no)
);
