CREATE TABLE [cus].[OITB] (
    [ItmsGrpCod] SMALLINT NOT NULL,
    [ItmsGrpNam] NVARCHAR(100) NOT NULL,
    [Locked] CHAR(1) NULL,
    CONSTRAINT [PK_erp_cus_OITB] PRIMARY KEY (ItmsGrpCod)
);
