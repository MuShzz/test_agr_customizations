CREATE TABLE [ax_cus].[ECORESCATEGORYHIERARCHY] (
    [NAME] NVARCHAR(128) NOT NULL,
    [HIERARCHYMODIFIER] INT NOT NULL,
    [RECVERSION] INT NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    CONSTRAINT [PK_ax_cus_ECORESCATEGORYHIERARCHY] PRIMARY KEY (RECID)
);
