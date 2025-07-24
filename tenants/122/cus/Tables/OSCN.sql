CREATE TABLE [cus].[OSCN] (
    [ItemCode] NVARCHAR(50) NOT NULL,
    [CardCode] NVARCHAR(15) NOT NULL,
    [Substitute] NVARCHAR(50) NOT NULL,
    CONSTRAINT [PK_erp_cus_OSCN] PRIMARY KEY (CardCode,ItemCode,Substitute)
);
