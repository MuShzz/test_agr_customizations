CREATE TABLE [bc_rest_cus].[item_extra_info] (
    [No] NVARCHAR(20) NOT NULL,
    [Item_subject_1] NVARCHAR(100) NULL,
    [Item_subject_2] NVARCHAR(100) NULL,
    [Unit_Price] DECIMAL(18,4) NULL,
    [Foreign_Purchase_Price] DECIMAL(18,4) NULL,
    [Currency_Code] NVARCHAR(50) NULL,
    [Substitute_1] NVARCHAR(50) NULL,
    [Substitute_2] NVARCHAR(50) NULL,
    [Substitute_3] NVARCHAR(50) NULL,
    [LastPurchaseDate] DATE NULL,
    CONSTRAINT [pk_bc_rest_cus_item_extra_info] PRIMARY KEY (No)
);
