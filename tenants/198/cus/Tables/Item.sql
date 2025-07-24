CREATE TABLE [cus].[Item] (
    [Product] NVARCHAR(128) NOT NULL,
    [ProductType] NVARCHAR(128) NULL,
    [CrossPlantStatus] NVARCHAR(128) NULL,
    [CrossPlantStatusValidityDate] NVARCHAR(128) NULL,
    [CreationDate] DATETIME2 NULL,
    [LastChangeDate] DATETIME2 NULL,
    [IsMarkedForDeletion] BIT NULL,
    [GrossWeight] NVARCHAR(128) NULL,
    [WeightUnit] NVARCHAR(128) NULL,
    [NetWeight] NVARCHAR(128) NULL,
    [ProductGroup] NVARCHAR(128) NULL,
    [ProductOldID] NVARCHAR(255) NULL,
    CONSTRAINT [PK_cus_Item] PRIMARY KEY (Product)
);
