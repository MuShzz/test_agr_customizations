CREATE TABLE [ax_cus].[INVENTDIM] (
    [INVENTDIMID] NVARCHAR(20) NULL,
    [INVENTBATCHID] NVARCHAR(20) NOT NULL,
    [INVENTSTATUSID] NVARCHAR(10) NOT NULL,
    [INVENTLOCATIONID] NVARCHAR(15) NULL,
    [INVENTSIZEID] NVARCHAR(10) NOT NULL,
    [INVENTCOLORID] NVARCHAR(10) NOT NULL,
    [INVENTSTYLEID] NVARCHAR(10) NOT NULL,
    [INVENTSITEID] NVARCHAR(10) NOT NULL,
    [DATAAREAID] NVARCHAR(4) NULL,
    [PARTITION] BIGINT NULL,
    [RECID] BIGINT NULL
);
