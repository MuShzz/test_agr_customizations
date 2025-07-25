CREATE TABLE [ax_cus].[SALESLINE] (
    [SALESID] NVARCHAR(20) NOT NULL,
    [ITEMID] NVARCHAR(20) NOT NULL,
    [SALESSTATUS] INT NOT NULL,
    [QTYORDERED] NUMERIC(32,16) NOT NULL,
    [INVENTTRANSID] NVARCHAR(20) NOT NULL,
    [REMAININVENTPHYSICAL] NUMERIC(32,16) NOT NULL,
    [INVENTDIMID] NVARCHAR(20) NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    [SALESTYPE] INT NOT NULL,
    CONSTRAINT [PK_ax_cus_SALESLINE] PRIMARY KEY (DATAAREAID,INVENTTRANSID,PARTITION)
);
