CREATE TABLE [bc_rest_cus].[assembly_line] (
    [AL_Document_Type] NVARCHAR(20) NULL,
    [AL_Document_No] NVARCHAR(20) NOT NULL,
    [AL_Line_No] NVARCHAR(20) NOT NULL,
    [AL_Remaining_Quantity_Base] DECIMAL(38,20) NOT NULL,
    [AL_Due_Date] DATETIME2 NOT NULL,
    [AL_Item_No] NVARCHAR(20) NULL,
    [AL_Variant_Code] NVARCHAR(20) NULL
);
