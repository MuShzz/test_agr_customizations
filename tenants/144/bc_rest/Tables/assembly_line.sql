CREATE TABLE [bc_rest_cus].[assembly_line] (
    [DocumentType] NVARCHAR(50) NOT NULL,
    [DocumentNo] NVARCHAR(20) NOT NULL,
    [LineNo] INT NOT NULL,
    [No] NVARCHAR(20) NOT NULL,
    [VariantCode] NVARCHAR(10) NOT NULL,
    [RemainingQuantityBase] DECIMAL(38,20) NOT NULL,
    [DueDate] DATE NOT NULL,
    [Quantity] DECIMAL(38,20) NULL,
    CONSTRAINT [PK_bc_rest_assembly_line] PRIMARY KEY (DocumentNo,DocumentType,LineNo,No,VariantCode)
);
