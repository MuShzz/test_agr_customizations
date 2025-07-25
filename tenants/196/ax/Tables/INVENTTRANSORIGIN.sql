CREATE TABLE [ax_cus].[INVENTTRANSORIGIN] (
    [INVENTTRANSID] NVARCHAR(20) NOT NULL,
    [REFERENCECATEGORY] INT NOT NULL,
    [REFERENCEID] NVARCHAR(20) NOT NULL,
    [ITEMID] NVARCHAR(20) NOT NULL,
    [ITEMINVENTDIMID] NVARCHAR(20) NOT NULL,
    [PARTY] BIGINT NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [RECVERSION] INT NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    CONSTRAINT [PK_erp_cus_INVENTTRANSORIGIN] PRIMARY KEY (RECID)
);
