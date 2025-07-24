CREATE TABLE [visma_sql_cus].[StcBal] (
    [ProdNo] NVARCHAR(250) NOT NULL,
    [StcNo] NVARCHAR(50) NOT NULL,
    [NrmSup] INT NOT NULL,
    [NrmLoc] NVARCHAR(250) NOT NULL,
    [PurcProc] INT NULL,
    [MinBalD] NVARCHAR(50) NULL,
    [Bal] DECIMAL(18,4) NULL,
    [StcInc] DECIMAL(18,4) NULL,
    [MinBal] NVARCHAR(50) NULL,
    [EcPurcQ] NVARCHAR(50) NULL,
    [PhCstPr] NVARCHAR(50) NULL,
    [LSaleDt] NVARCHAR(50) NULL,
    [MaxBal] NVARCHAR(50) NULL,
    [PurcPnt] NVARCHAR(50) NULL,
    [PurcInt] NVARCHAR(50) NULL,
    [InProd] NVARCHAR(50) NULL,
    [InProdO] NVARCHAR(50) NULL
);
