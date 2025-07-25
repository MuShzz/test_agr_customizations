CREATE TABLE [ax_cus].[RETAILCHANNELTABLE] (
    [ONLINECATALOGNAME] NVARCHAR(128) NULL,
    [STORENUMBER] NVARCHAR(10) NULL,
    [CLOSINGMETHOD] INT NULL,
    [FUNCTIONALITYPROFILE] NVARCHAR(10) NULL,
    [INVENTORYLOOKUP] INT NULL,
    [REMOVEADDTENDER] NVARCHAR(10) NULL,
    [CATEGORYHIERARCHY] BIGINT NOT NULL,
    [CHANNELTYPE] INT NOT NULL,
    [DEFAULTDIMENSION] BIGINT NOT NULL,
    [INVENTLOCATION] NVARCHAR(10) NOT NULL,
    [INVENTLOCATIONDATAAREAID] NVARCHAR(4) NOT NULL,
    [OMOPERATINGUNITID] BIGINT NOT NULL,
    [STOREAREA] NUMERIC(32,16) NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    CONSTRAINT [PK_ax_cus_RETAILCHANNELTABLE] PRIMARY KEY (RECID)
);
