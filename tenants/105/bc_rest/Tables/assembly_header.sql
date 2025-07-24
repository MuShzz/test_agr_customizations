CREATE TABLE [bc_rest_cus].[assembly_header] (
    [AH_Document_Type] NVARCHAR(20) NOT NULL,
    [AH_No] NVARCHAR(20) NOT NULL,
    [AH_Status] NVARCHAR(20) NOT NULL,
    [AH_Location_Code] NVARCHAR(20) NOT NULL,
    CONSTRAINT [PK_dbo_assembly_header] PRIMARY KEY (AH_Document_Type,AH_No)
);
