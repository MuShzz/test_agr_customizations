CREATE TABLE [cus].[SystemCategory] (
    [CategoryCode] NVARCHAR(30) NOT NULL,
    [ParentCategory] NVARCHAR(30) NULL,
    [IsActive] BIT NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_SystemCategory] PRIMARY KEY (CategoryCode)
);
