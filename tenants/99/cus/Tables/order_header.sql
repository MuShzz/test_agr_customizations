CREATE TABLE [cus].[order_header] (
    [oh_id] INT NOT NULL,
    [oh_order_number] NVARCHAR(30) NOT NULL,
    [oh_datetime] DATETIME NOT NULL,
    [oh_cd_id] INT NULL,
    [oh_sot_id] INT NULL,
    [oh_os_id] INT NULL,
    [oh_sl_id] INT NULL,
    CONSTRAINT [pk_cus_oh_id] PRIMARY KEY (oh_id)
);
