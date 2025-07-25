CREATE TABLE [ax_cus].[INVENTTRANS] (
    [ITEMID] NVARCHAR(20) NOT NULL,
    [STATUSISSUE] INT NOT NULL,
    [DATEPHYSICAL] DATETIME NOT NULL,
    [QTY] NUMERIC(32,16) NOT NULL,
    [INVOICEID] NVARCHAR(20) NOT NULL,
    [DATEFINANCIAL] DATETIME NOT NULL,
    [STATUSRECEIPT] INT NOT NULL,
    [INVENTDIMID] NVARCHAR(20) NOT NULL,
    [INVENTTRANSORIGIN] BIGINT NOT NULL,
    [MODIFIEDDATETIME] DATETIME NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL
);
