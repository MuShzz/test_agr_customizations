CREATE TABLE [cus].[OADM] (
    [Code] INT NOT NULL,
    [CompnyName] NVARCHAR(100) NULL,
    [CompnyAddr] NVARCHAR(254) NULL,
    [Country] NVARCHAR(3) NULL,
    [PrintHeadr] NVARCHAR(100) NULL,
    [Phone1] NVARCHAR(20) NULL,
    [Phone2] NVARCHAR(20) NULL,
    [Fax] NVARCHAR(20) NULL,
    [E_Mail] NVARCHAR(100) NULL,
    [Manager] NVARCHAR(100) NULL,
    [CompType] CHAR(1) NULL,
    [MainCurncy] NVARCHAR(3) NULL,
    [SysCurrncy] NVARCHAR(3) NULL,
    CONSTRAINT [PK_erp_cus_OADM] PRIMARY KEY (Code)
);
