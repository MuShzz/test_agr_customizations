CREATE TABLE [ax_cus].[BYKVENDLEADTIME] (
    [ITEMID] NVARCHAR(20) NOT NULL,
    [LEADTIME] INT NOT NULL,
    [VENDACCOUNT] NVARCHAR(20) NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [RECVERSION] INT NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    CONSTRAINT [PK_erp_cus_BYKVENDLEADTIME] PRIMARY KEY (RECID)
);
