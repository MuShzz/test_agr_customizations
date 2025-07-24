CREATE TABLE [cus].[transfer_order] (
    [no] NVARCHAR(128) NOT NULL,
    [original_to_no] NVARCHAR(128) NULL,
    [location_no] NVARCHAR(255) NOT NULL,
    [order_from_location_no] NVARCHAR(255) NOT NULL,
    [delivery_date] DATE NULL,
    [deliv_status] TINYINT NOT NULL,
    CONSTRAINT [PK_cus_transfer_order] PRIMARY KEY (no)
);
