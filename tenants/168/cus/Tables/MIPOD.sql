CREATE TABLE [cus].[MIPOD] (
    [pohId] NVARCHAR(24) NOT NULL,
    [podId] INT NOT NULL,
    [pohRev] SMALLINT NULL,
    [dType] SMALLINT NULL,
    [dStatus] SMALLINT NULL,
    [locId] NVARCHAR(6) NULL,
    [itemId] NVARCHAR(24) NULL,
    [ordered] DECIMAL(20,6) NULL,
    [received] DECIMAL(20,6) NULL,
    [initDueDate] NVARCHAR(8) NULL,
    [realDueDate] NVARCHAR(8) NULL
);
