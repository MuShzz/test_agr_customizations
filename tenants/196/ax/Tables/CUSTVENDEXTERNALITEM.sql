CREATE TABLE [ax_cus].[CUSTVENDEXTERNALITEM] (
    [ITEMID] NVARCHAR(20) NOT NULL,
    [MODULETYPE] INT NOT NULL,
    [CUSTVENDRELATION] NVARCHAR(20) NOT NULL,
    [EXTERNALITEMTXT] NVARCHAR(1000) NULL,
    [EXTERNALITEMID] NVARCHAR(20) NOT NULL,
    [ABCCATEGORY] NVARCHAR(10) NOT NULL,
    [DESCRIPTION] NVARCHAR(60) NOT NULL,
    [INVENTDIMID] NVARCHAR(20) NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [RECVERSION] NVARCHAR(10) NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    [BYKVENDPRIORITY] NVARCHAR(10) NOT NULL,
    [BYKVENDUNITID] NVARCHAR(10) NULL
);
