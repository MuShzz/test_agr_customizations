CREATE TABLE [bc_rest_cus].[assembly_header] (
    [DocumentType] NVARCHAR(50) NOT NULL,
    [No] NVARCHAR(20) NOT NULL,
    [ItemNo] NVARCHAR(20) NOT NULL,
    [VariantCode] NVARCHAR(10) NOT NULL,
    [Status] NVARCHAR(20) NOT NULL,
    [Quantity] DECIMAL(38,20) NULL,
    [QuantityToAssemble] DECIMAL(38,20) NULL,
    CONSTRAINT [PK_bc_rest_assembly_header] PRIMARY KEY (DocumentType,ItemNo,No,VariantCode)
);
