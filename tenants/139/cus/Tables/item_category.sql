CREATE TABLE [cus].[item_category] (
    [Code] VARCHAR(20) NOT NULL,
    [Description] VARCHAR(100) NOT NULL,
    [HasChildren] BIT NULL,
    [ParentCategory] VARCHAR(20) NULL,
    [PresentationOrder] INT NULL,
    [Indentation] INT NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [pk_cus_item_category] PRIMARY KEY (Code,Company)
);
