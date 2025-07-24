CREATE TABLE [cus].[UnitOfMeasureSetRelatedUnit] (
    [FQPrimaryKey] NVARCHAR(255) NOT NULL,
    [ListID] NVARCHAR(255) NOT NULL,
    [TimeCreated] DATETIME2 NULL,
    [TimeModified] DATETIME2 NULL,
    [EditSequence] NVARCHAR(255) NULL,
    [Name] NVARCHAR(255) NULL,
    [IsActive] BIT NULL,
    [UnitOfMeasureType] NVARCHAR(255) NULL,
    [BaseUnitName] NVARCHAR(255) NULL,
    [BaseUnitAbbreviation] NVARCHAR(255) NULL,
    [RelatedUnitSeqNo] INT NULL,
    [RelatedUnitName] NVARCHAR(255) NULL,
    [RelatedUnitAbbreviation] NVARCHAR(255) NULL,
    [RelatedUnitConversionRatio] DECIMAL(16,5) NULL,
    [FQSaveToCache] BIT NULL,
    CONSTRAINT [PK_cus_UnitOfMeasureSetRelatedUnit] PRIMARY KEY (ListID)
);
