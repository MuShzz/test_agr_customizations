CREATE TABLE [cus].[Actor] (
    [ActNo] INT NOT NULL,
    [Nm] NVARCHAR(250) NOT NULL,
    [SupNo] INT NULL,
    [CustNo] INT NULL,
    [Ctry] INT NULL,
    [Seller] INT NULL,
    [EmpNo] INT NOT NULL,
    CONSTRAINT [PK_cus_Actor] PRIMARY KEY (ActNo)
);
