CREATE TABLE [visma_sql_cus].[Actor] (
    [ActNo] INT NOT NULL,
    [Nm] NVARCHAR(250) NOT NULL,
    [SupNo] INT NULL,
    [CustNo] INT NULL,
    [Ctry] INT NULL,
    [Seller] INT NULL,
    [EmpNo] INT NOT NULL,
    [AdmTm] INT NOT NULL,
    [ProdTm] INT NOT NULL,
    [DelTm] INT NOT NULL,
    [TanspTm] INT NOT NULL,
    [Gr10] INT NOT NULL,
    [Cur] INT NOT NULL,
    CONSTRAINT [PK_visma_sql_cus_Actor] PRIMARY KEY (ActNo)
);
