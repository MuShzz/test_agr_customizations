CREATE TABLE [ogl_cus].[WOOrders] (
    [stcode] NVARCHAR(24) NOT NULL,
    [wordno] INT NOT NULL,
    [depot] NVARCHAR(2) NULL,
    [quan] DECIMAL(18,4) NULL,
    [ordref] NVARCHAR(15) NULL,
    [orddate] NVARCHAR(128) NULL,
    [duedate] NVARCHAR(128) NULL,
    [statusind] INT NULL
);
