CREATE TABLE [ax_cus].[ECORESPRODUCTCATEGORY] (
    [CATEGORYHIERARCHY] BIGINT NOT NULL,
    [CATEGORY] BIGINT NOT NULL,
    [PRODUCT] BIGINT NOT NULL,
    [MODIFIEDDATETIME] DATETIME NOT NULL,
    [RECVERSION] INT NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    CONSTRAINT [PK_ax_cus_ECORESPRODUCTCATEGORY] PRIMARY KEY (RECID)
);
