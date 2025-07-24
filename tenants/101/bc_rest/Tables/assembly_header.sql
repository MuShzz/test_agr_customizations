CREATE TABLE [bc_rest_cus].[assembly_header] (
    [DocumentType] VARCHAR(20) NOT NULL,
    [No] VARCHAR(20) NOT NULL,
    [Status] VARCHAR(20) NULL,
    [LocationCode] VARCHAR(10) NULL,
    CONSTRAINT [PK_dbo_assembly_header] PRIMARY KEY (DocumentType,No)
);
