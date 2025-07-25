CREATE TABLE [ax_cus].[WHSINVENTSTATUS] (
    [INVENTSTATUSID] NVARCHAR(10) NOT NULL,
    [NAME] NVARCHAR(60) NOT NULL,
    [INVENTSTATUSBLOCKING] INT NOT NULL,
    [MODIFIEDDATETIME] DATETIME NOT NULL,
    [MODIFIEDBY] NVARCHAR(8) NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [RECVERSION] INT NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    CONSTRAINT [PK_ax_cus_WHSINVENTSTATUS] PRIMARY KEY (DATAAREAID,INVENTSTATUSID,PARTITION)
);
