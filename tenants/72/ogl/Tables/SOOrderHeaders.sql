CREATE TABLE [ogl_cus].[SOOrderHeaders] (
    [cref] NVARCHAR(6) NULL,
    [ordno] INT NULL,
    [orddate] NVARCHAR(128) NULL,
    [deldate] NVARCHAR(128) NULL,
    [delcode] NVARCHAR(3) NULL,
    [depot] NVARCHAR(2) NULL,
    [actdate] NVARCHAR(128) NULL,
    [sqldeleteflag] NVARCHAR(1) NULL,
    [cashstat] NVARCHAR(1) NULL,
    [cashrcvd] NVARCHAR(1) NULL
);
