CREATE TABLE [bc_rest_cus].[Malmsteypan_LegacySales2020_2023_ExtraInfo] (
    [Entry_No] INT NULL,
    [Posting_Date] DATE NULL,
    [Entry_Type] NVARCHAR(MAX) NULL,
    [Document_Type] NVARCHAR(MAX) NULL,
    [Document_No] NVARCHAR(MAX) NULL,
    [Document_Line_No] INT NULL,
    [Item_No] NVARCHAR(50) NULL,
    [Variant_Code] NVARCHAR(50) NULL,
    [Location_Code] NVARCHAR(50) NULL,
    [Quantity] DECIMAL(18,10) NULL,
    [Invoiced_Quantity] DECIMAL(18,10) NULL,
    [Assemble_to_Order] BIT NULL
);
