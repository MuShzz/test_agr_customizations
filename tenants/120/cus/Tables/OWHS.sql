CREATE TABLE [cus].[OWHS] (
    [WhsCode] NCHAR(8) NULL,
    [WhsName] NCHAR(100) NULL,
    [IntrnalKey] NUMERIC(6,0) NULL,
    [Grp_Code] NCHAR(4) NULL,
    [BalInvntAc] NCHAR(15) NULL,
    [Locked] CHAR(1) NULL,
    [VatGroup] NCHAR(8) NULL,
    [Street] NCHAR(100) NULL,
    [Block] NCHAR(100) NULL,
    [ZipCode] NCHAR(20) NULL,
    [City] NCHAR(100) NULL,
    [County] NCHAR(100) NULL,
    [Country] NCHAR(3) NULL,
    [State] NCHAR(3) NULL,
    [Location] NUMERIC(6,0) NULL,
    [SaleCostAc] NCHAR(50) NULL
);
