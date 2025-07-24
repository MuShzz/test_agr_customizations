CREATE TABLE [cus].[Categories] (
    [id] NVARCHAR(100) NOT NULL,
    [categoryId] NVARCHAR(100) NULL,
    [name] NVARCHAR(255) NULL,
    [description] NVARCHAR(MAX) NULL,
    [parentId] NVARCHAR(100) NULL,
    [language] NVARCHAR(10) NULL,
    [isMainCategory] BIT NULL,
    [imageUrl] NVARCHAR(500) NULL,
    [isHidden] BIT NULL,
    [sortIndex] INT NULL,
    CONSTRAINT [PK__Categori__3213E83FF0CE8399] PRIMARY KEY (id)
);
