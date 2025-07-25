CREATE TABLE [ax_cus].[PURCHLINE] (
    [PURCHID] NVARCHAR(20) NOT NULL,
    [ITEMID] NVARCHAR(20) NOT NULL,
    [PURCHSTATUS] INT NOT NULL,
    [DELIVERYDATE] DATETIME NOT NULL,
    [QTYORDERED] NUMERIC(32,16) NOT NULL,
    [REMAINPURCHPHYSICAL] NUMERIC(32,16) NOT NULL,
    [PURCHPRICE] NUMERIC(32,16) NOT NULL,
    [LINEAMOUNT] NUMERIC(32,16) NOT NULL,
    [INVENTTRANSID] NVARCHAR(20) NOT NULL,
    [VENDGROUP] NVARCHAR(10) NOT NULL,
    [PURCHQTY] NUMERIC(32,16) NOT NULL,
    [INVENTREFID] NVARCHAR(20) NOT NULL,
    [BLOCKED] INT NOT NULL,
    [COMPLETE] INT NOT NULL,
    [INVENTDIMID] NVARCHAR(20) NOT NULL,
    [DEFAULTDIMENSION] BIGINT NOT NULL,
    [LEDGERDIMENSION] BIGINT NOT NULL,
    [ISDELETED] INT NOT NULL,
    [ISMODIFIED] INT NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    CONSTRAINT [PK_ax_cus_PURCHLINE] PRIMARY KEY (DATAAREAID,INVENTTRANSID,PARTITION)
);
