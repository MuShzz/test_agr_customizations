CREATE TABLE [cus].[MIITEM] (
    [itemId] NVARCHAR(24) NOT NULL,
    [descr] NVARCHAR(60) NOT NULL,
    [xdesc] NVARCHAR(2000) NOT NULL,
    [suplId] NVARCHAR(12) NULL,
    [lead] INT NULL,
    [minLvl] DECIMAL(18,6) NULL,
    [ref] NVARCHAR(48) NULL,
    [status] SMALLINT NULL,
    [ordQty] DECIMAL(20,6) NULL,
    [unitWgt] DECIMAL(20,6) NULL,
    [uOfM] NVARCHAR(20) NULL,
    [poUOfM] NVARCHAR(20) NULL,
    [sales] NVARCHAR(256) NULL
);
