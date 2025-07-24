CREATE TABLE [bc_rest_cus].[assembly_line] (
    [DocumentNo] VARCHAR(20) NOT NULL,
    [No] VARCHAR(20) NOT NULL,
    [RemainingQuantityBase] DECIMAL(38,20) NOT NULL,
    [DueDate] DATETIME2 NOT NULL,
    [AUZItemNo2] VARCHAR(20) NULL,
    [AuxiliaryIndex1] VARCHAR(20) NULL,
    [AuxiliaryIndex2] INT NULL
);
