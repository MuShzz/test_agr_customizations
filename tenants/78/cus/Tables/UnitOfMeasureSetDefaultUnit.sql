CREATE TABLE [cus].[UnitOfMeasureSetDefaultUnit] (
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
    [DefaultUnitUnitSeqNo] INT NULL,
    [DefaultUnitUnitUsedFor] NVARCHAR(255) NULL,
    [DefaultUnitUnit] NVARCHAR(255) NULL,
    CONSTRAINT [PK_cus_UnitOfMeasureSetDefaultUnit] PRIMARY KEY (FQPrimaryKey)
);
